class Serializable::Drawing < Serializable

  attr_accessor :content

  # drawing png
  extend CarrierWave::Mount
  mount_uploader :attachment, DocumentUploader
  attr_accessor :static_attachment_url

end
