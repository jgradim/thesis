class Serializable::Image < Serializable

  attr_accessor :photo_id
  
  def photo
    Photo.find(@photo_id)
  end
  
end
