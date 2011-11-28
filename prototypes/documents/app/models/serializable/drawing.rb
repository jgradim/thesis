class Serializable::Drawing < Serializable

  attr_accessor :content

  # drawing png
  attaches :image,
           :allowed_extensions => %w(png)

end
