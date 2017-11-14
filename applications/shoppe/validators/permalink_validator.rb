class PermalinkValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[A-z0-9\-_]+\Z/
      record.errors.add(attribute, :wrong_format)
    end
  end
end
