# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support
  #     include CarrierWave::RMagick
  #     include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.block_id}"
  end

  after :store, :add_attachment_url
  def add_attachment_url(*args)
    static_url_attr = "static_#{mounted_as.to_s}_url".to_sym
    model.send("#{static_url_attr}=", model.send(mounted_as).url)
  end

  def extension_white_list
    model.class.allowed_extensions
  end
end
