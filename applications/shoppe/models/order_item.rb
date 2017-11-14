  class OrderItem < ActiveRecord::Base
    self.table_name = 'shoppe_order_items'

    # The associated order
    #
    # @return [Order]
    belongs_to :order, class_name: 'Order', touch: true, inverse_of: :order_items

    # The item which has been ordered
    belongs_to :ordered_item, polymorphic: true

    # Any stock level adjustments which have been made for this order item
    has_many :stock_level_adjustments, as: :parent, dependent: :nullify, class_name: 'StockLevelAdjustment'

    # Validations
    validates :quantity, numericality: true
    validates :ordered_item, presence: true

    validate do
      errors.add :quantity, :too_high_quantity unless in_stock?
    end

    # Before saving an order item which belongs to a received order, cache the pricing again if appropriate.
    before_save do
      if order.received? && (unit_price_changed? || unit_cost_price_changed? || tax_rate_changed? || tax_amount_changed?)
        cache_pricing
      end
    end

    # After saving, if the order has been shipped, reallocate stock appropriate
    after_save do
      allocate_unallocated_stock! if order.shipped?
    end

    # This allows you to add a product to the scoped order. For example Order.first.order_items.add_product(...).
    # This will either increase the quantity of the value in the order or create a new item if one does not
    # exist already.
    #
    # @param ordered_item [Object] an object which implements the OrderableItem protocol
    # @param quantity [Fixnum] the number of items to order
    # @return [OrderItem]
    def self.add_item(ordered_item, quantity = 1)
      fail Errors::UnorderableItem, ordered_item: ordered_item unless ordered_item.orderable?
      transaction do
        if existing = where(ordered_item_id: ordered_item.id, ordered_item_type: ordered_item.class.to_s).first
          existing.increase!(quantity)
          existing
        else
          new_item = create(ordered_item: ordered_item, quantity: 0)
          new_item.increase!(quantity)
          new_item
        end
      end
    end

    # Remove a product from an order. It will also ensure that the order's custom delivery
    # service is updated if appropriate.
    #
    # @return [OrderItem]
    def remove
      transaction do
        destroy!
        order.remove_delivery_service_if_invalid
        self
      end
    end

    # Increases the quantity of items in the order by the number provided. Will raise an error if we don't have
    # the stock to do this.
    #
    # @param quantity [Fixnum]
    def increase!(amount = 1)
      transaction do
        self.quantity += amount
        unless in_stock?
          fail Errors::NotEnoughStock, ordered_item: ordered_item, requested_stock: self.quantity
        end
        save!
        order.remove_delivery_service_if_invalid
      end
    end

    # Decreases the quantity of items in the order by the number provided.
    #
    # @param amount [Fixnum]
    def decrease!(amount = 1)
      transaction do
        self.quantity -= amount
        self.quantity == 0 ? destroy : save!
        order.remove_delivery_service_if_invalid
      end
    end

    # The total weight of the item
    #
    # @return [BigDecimal]
    def weight
      read_attribute(:weight) || ordered_item.try(:weight) || BigDecimal(0)
    end

    # Return the total weight of the item
    #
    # @return [BigDecimal]
    def total_weight
      quantity * weight
    end

    # The unit price for the item
    #
    # @return [BigDecimal]
    def unit_price
      read_attribute(:unit_price) || ordered_item.try(:price) || BigDecimal(0)
    end

    # The cost price for the item
    #
    # @return [BigDecimal]
    def unit_cost_price
      read_attribute(:unit_cost_price) || ordered_item.try(:cost_price) || BigDecimal(0)
    end

    # The tax rate for the item
    #
    # @return [BigDecimal]
    def tax_rate
      read_attribute(:tax_rate) || ordered_item.try(:tax_rate).try(:rate_for, order) || BigDecimal(0)
    end

    # The total tax for the item
    #
    # @return [BigDecimal]
    def tax_amount
      read_attribute(:tax_amount) || (sub_total / BigDecimal(100)) * tax_rate
    end

    # The total cost for the product
    #
    # @return [BigDecimal]
    def total_cost
      quantity * unit_cost_price
    end

    # The sub total for the product
    #
    # @return [BigDecimal]
    def sub_total
      quantity * unit_price
    end

    # The total price including tax for the order line
    #
    # @return [BigDecimal]
    def total
      tax_amount + sub_total
    end

    # Cache the pricing for this order item
    def cache_pricing
      write_attribute :weight, weight
      write_attribute :unit_price, unit_price
      write_attribute :unit_cost_price, unit_cost_price
      write_attribute :tax_rate, tax_rate
    end

    # Cache the pricing for this order item and save
    def cache_pricing!
      cache_pricing
      save!
    end

    # Trigger when the associated order is confirmed. It handles caching the values
    # of the monetary items and allocating stock as appropriate.
    def confirm!
      cache_pricing!
      allocate_unallocated_stock!
    end

    # Trigger when the associated order is accepted
    def accept!
    end

    # Trigged when the associated order is rejected..
    def reject!
      stock_level_adjustments.destroy_all
    end

    # Do we have the stock needed to fulfil this order?
    #
    # @return [Boolean]
    def in_stock?
      if ordered_item && ordered_item.stock_control?
        ordered_item.stock >= unallocated_stock
      else
        true
      end
    end

    # How much stock remains to be allocated for this order?
    #
    # @return [Fixnum]
    def unallocated_stock
      self.quantity - allocated_stock
    end

    # How much stock has been allocated to this item?
    #
    # @return [Fixnum]
    def allocated_stock
      0 - stock_level_adjustments.sum(:adjustment)
    end

    # Validate the stock level against the product and update as appropriate. This method will be executed
    # before an order is completed. If we have run out of this product, we will update the quantity to an
    # appropriate level (or remove the order item) and return the object.
    def validate_stock_levels
      if in_stock?
        false
      else
        self.quantity = ordered_item.stock
        self.quantity == 0 ? destroy : save!
        self
      end
    end

    # Allocate any unallocated stock for this order item. There is no return value.
    def allocate_unallocated_stock!
      if ordered_item.stock_control? && unallocated_stock != 0
        ordered_item.stock_level_adjustments.create!(parent: self, adjustment: 0 - unallocated_stock, description: "Order ##{order.number}")
      end
    end
  end
