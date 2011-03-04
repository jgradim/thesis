class DocumentItem::Marker < DocumentItem

  attr_accessor :lat, :lng, :title, :icon
  
  defaults :title, ""
  defaults :icon,  ""

end
