module LocalizationUtils
  module_function

  # Check if the country code (ISO 3166-1 alpha-2) is valid (i.e. sv_SE -> SE is the country code)
  def country_code_valid?(country_code)
    unless country_code.blank?
      CountrySelect.countries.select{|key, hash|
        return true if key.downcase == country_code.downcase
      }
    end
    return false
  end

  def valid_country_code(code)
    country_code_valid?(code) ? code.downcase : "us" # defaults to us, should not happen to new marketplaces
  end
end
