class DocumentItem::Drawing < DocumentItem

  attr_accessor :content
  
  # attachments
  extend CarrierWave::Mount
  mount_uploader :attachment, DocumentUploader
  attr_accessor :static_attachment_url
  
end
