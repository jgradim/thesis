class Serializable::Drawing < Serializable

  attr_accessor :content

  # drawing png
  attaches :image,
           :allowed_extensions => %(png)

end
