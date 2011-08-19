class Serializable::Scratch < Serializable

  #extend CarrierWave::Mount
  #mount_uploader :scratch_uploader
  #attr_accessor :static_attachment_url
  attaches :source_file,
           :allowed_extensions => %(sb)

end
