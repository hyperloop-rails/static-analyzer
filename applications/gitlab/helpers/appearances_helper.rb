module AppearancesHelper
  def brand_title
    if brand_item && brand_item.title
      brand_item.title
    else
      'GitLab Community Edition'
    end
  end

  def brand_image
    if brand_item.logo?
      image_tag brand_item.logo
    else
      nil
    end
  end

  def brand_text
    markdown(brand_item.description)
  end

  def brand_item
    @appearance ||= Appearance.first
  end

  def brand_header_logo
    if brand_item && brand_item.header_logo?
      image_tag brand_item.header_logo
    else
      render 'shared/logo.svg'
    end
  end
end
