class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  # storage :file
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fill: [800, 350]
  
end
