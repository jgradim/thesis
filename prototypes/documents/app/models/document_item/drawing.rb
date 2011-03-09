class DocumentItem::Drawing < DocumentItem

  attr_accessor :content
  
  extend CarrierWave::Mount
  mount_uploader :attachment, DocumentUploader
  attr_accessor :static_attachment_url
  
end
