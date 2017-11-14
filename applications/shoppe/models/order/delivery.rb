  class Order < ActiveRecord::Base
    # The associated delivery service
    #
    # @return [DeliveryService]
    belongs_to :delivery_service, class_name: 'DeliveryService'

    # The country where this order is being delivered to (if one has been provided)
    #
    # @return [Country]
    belongs_to :delivery_country, class_name: 'Country', foreign_key: 'delivery_country_id'

    # The user who marked the order has shipped
    #
    # @return [User]
    belongs_to :shipper, class_name: 'User', foreign_key: 'shipped_by'

    # Set up a callback for use when an order is shipped
    define_model_callbacks :ship

    # Validations
    with_options if: :separate_delivery_address? do |order|
      order.validates :delivery_name, presence: true
      order.validates :delivery_address1, presence: true
      order.validates :delivery_address3, presence: true
      order.validates :delivery_address4, presence: true
      order.validates :delivery_postcode, presence: true
      order.validates :delivery_country, presence: true
    end

    validate do
      if delivery_required?
        if delivery_service.nil?
          errors.add :delivery_service_id, :must_be_specified
        elsif !valid_delivery_service?
          errors.add :delivery_service_id, :not_suitable
        end
      end
    end

    before_confirmation do
      # Ensure that before we confirm the order that the delivery service which has been selected
      # is appropritae for the contents of the order.
      if delivery_required? && !valid_delivery_service?
        fail Errors::InappropriateDeliveryService, order: self
      end
      cache_delivery_pricing
    end

    # If an order has been received and something changes the delivery service or the delivery price
    # is cleared, we will re-cache all the delivery pricing so that we have the latest.
    before_save do
      if received? && (delivery_service_id_changed? || (delivery_price_changed? && read_attribute(:delivery_price).blank?))
        self.delivery_price = nil
        self.delivery_cost_price = nil
        self.delivery_tax_rate = nil
        self.delivery_tax_amount = nil
        cache_delivery_pricing
      end
    end

    # If there isn't a seperate address needed, clear all the fields back to nil
    before_validation do
      unless separate_delivery_address?
        self.delivery_name = nil
        self.delivery_address1 = nil
        self.delivery_address2 = nil
        self.delivery_address3 = nil
        self.delivery_address4 = nil
        self.delivery_postcode = nil
        self.delivery_country = nil
      end
    end

    # Create some delivery_ methods which will mimic the billing methods if the order does
    # not need a seperate address.
    [:delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country].each do |f|
      define_method(f) do
        separate_delivery_address? ? super() : send(f.to_s.gsub('delivery_', 'billing_'))
      end
    end

    # Cache delivery prices for the order
    def cache_delivery_pricing
      if delivery_service
        write_attribute :delivery_service_id, delivery_service.id
        write_attribute :delivery_price, delivery_price
        write_attribute :delivery_cost_price, delivery_cost_price
        write_attribute :delivery_tax_rate, delivery_tax_rate
      else
        write_attribute :delivery_service_id, nil
        write_attribute :delivery_price, nil
        write_attribute :delivery_cost_price, nil
        write_attribute :delivery_tax_rate, nil
        write_attribute :delivery_tax_amount, nil
      end
    end

    # Cache prices and save the order
    def cache_delivery_pricing!
      cache_delivery_pricing
      save!
    end

    # Has this order been shipped?
    #
    # @return [Boolean]
    def shipped?
      !!shipped_at?
    end

    # The total weight of the order
    #
    # @return [BigDecimal]
    def total_weight
      order_items.inject(BigDecimal(0)) { |t, i| t + i.total_weight }
    end

    # Is delivery required for this order?
    #
    # @return [Boolean]
    def delivery_required?
      total_weight > BigDecimal(0)
    end

    # An array of all the delivery services which are suitable for this order in it's
    # current state (based on its current weight)
    #
    # @return [Array] an array of DeliveryService objects
    def available_delivery_services
      delivery_service_prices.map(&:delivery_service).uniq
    end

    # An array of all the delivery service prices which can be applied to this order.
    #
    # @return [Array] an array of Shoppe:DeliveryServicePrice objects
    def delivery_service_prices
      if delivery_required?
        prices = DeliveryServicePrice.joins(:delivery_service).where(shoppe_delivery_services: { active: true }).order(:price).for_weight(total_weight)
        prices = prices.select { |p| p.countries.empty? || p.country?(delivery_country) }
        prices.sort { |x, y| (y.delivery_service.default? ? 1 : 0) <=> (x.delivery_service.default? ? 1 : 0) } # Order by truthiness
      else
        []
      end
    end

    # The recommended delivery service for this order
    #
    # @return [DeliveryService]
    def delivery_service
      super || available_delivery_services.first
    end

    # Return the delivery price for this order in its current state
    #
    # @return [BigDecimal]
    def delivery_service_price
      delivery_service && delivery_service_prices.find { |price| price.delivery_service == delivery_service }
    end

    # The price for delivering this order in its current state
    #
    # @return [BigDecimal]
    def delivery_price
      read_attribute(:delivery_price) || delivery_service_price.try(:price) || BigDecimal(0)
    end

    # The cost of delivering this order in its current state
    #
    # @return [BigDecimal]
    def delivery_cost_price
      read_attribute(:delivery_cost_price) || delivery_service_price.try(:cost_price) || BigDecimal(0)
    end

    # The tax amount due for the delivery of this order in its current state
    #
    # @return [BigDecimal]
    def delivery_tax_amount
      read_attribute(:delivery_tax_amount) ||
        delivery_price / BigDecimal(100) * delivery_tax_rate
    end

    # The tax rate for the delivery of this order in its current state
    #
    # @return [BigDecimal]
    def delivery_tax_rate
      read_attribute(:delivery_tax_rate) ||
        delivery_service_price.try(:tax_rate).try(:rate_for, self) ||
        BigDecimal(0)
    end

    # Is the currently assigned delivery service appropriate for this order?
    #
    # @return [Boolean]
    def valid_delivery_service?
      delivery_service ? available_delivery_services.include?(delivery_service) : !delivery_required?
    end

    # Remove the associated delivery service if it's invalid
    def remove_delivery_service_if_invalid
      unless valid_delivery_service?
        self.delivery_service = nil
        save
      end
    end

    # The URL which can be used to track the delivery of this order
    #
    # @return [String]
    def courier_tracking_url
      return nil if shipped_at.blank? || consignment_number.blank?
      @courier_tracking_url ||= delivery_service.tracking_url_for(self)
    end

    # Mark this order as shipped
    def ship!(consignment_number, user = nil)
      run_callbacks :ship do
        self.shipped_at = Time.now
        self.shipper = user if user
        self.status = 'shipped'
        self.consignment_number = consignment_number
        save!
        OrderMailer.shipped(self).deliver
      end
    end
  end
