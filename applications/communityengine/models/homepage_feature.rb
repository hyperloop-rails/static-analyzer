class HomepageFeature < ActiveRecord::Base  
  has_attached_file :image, configatron.feature.paperclip_options.to_hash
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => configatron.feature.validation_options.content_type
  validates_attachment_size :image, :less_than => configatron.feature.validation_options.max_size.to_i.megabytes

  validates_presence_of :url
  
  def self.find_features
    order("created_at DESC")
  end

end
