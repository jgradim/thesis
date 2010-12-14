class DocumentItem::Marker < DocumentItem

  attr_accessor :lat, :lng, :title
  defaults :title => ""

end
