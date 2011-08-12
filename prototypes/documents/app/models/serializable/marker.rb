class Serializable::Marker < Serializable

  attr_accessor :lat, :lng, :title, :icon
  
  defaults :lat,   0.0
  defaults :lng,   0.0
  defaults :title, ""
  defaults :icon,  ""

end
