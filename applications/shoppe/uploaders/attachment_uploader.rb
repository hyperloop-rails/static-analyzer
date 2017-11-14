# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Where should files be stored?
  def store_dir
    "attachment/#{model.id}"
  end

  # Returns true if the file is an image
  def image?(_new_file)
    file.content_type.include? 'image'
  end

  # Returns true if the file is not an image
  def not_image?(_new_file)
    !file.content_type.include? 'image'
  end

  # Create different versions of your uploaded files:
  version :thumb, if: :image? do
    process resize_and_pad: [200, 200]
  end
end
