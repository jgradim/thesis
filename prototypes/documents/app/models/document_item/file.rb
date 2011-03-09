class DocumentItem::File < DocumentItem

  attr_accessor :attachment_file_id
  
  def attachment_file
    AttachmentFile.find(@attachment_file_id)
  end
  
end
