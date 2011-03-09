class DocumentItem::Image < DocumentItem

  attr_accessor :photo_id
  
  def photo
    Photo.find(@photo_id)
  end
  
end
