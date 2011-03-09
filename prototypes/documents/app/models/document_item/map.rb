class DocumentItem::Map < DocumentItem

  attr_accessor :lat, :lng, :map_type, :markers
  
  defaults :lat,     0.0
  defaults :lng,     0.0
  defaults :mode,    'roadmap'
  defaults :zoom,    8
  defaults :markers, []
  
end
