class DocumentItem::Map < DocumentItem

  attr_accessor :lat, :lng, :map_type, :markers
  @defaults = {
    :markers => []
  }
  
end
