class DocumentItem::Drawing < DocumentItem

  attr_accessor :content
  
  #has_attached_file :image,
  #                  :url  =>                   "/assets/drawings/:id/:basename.:extension",
  #                  :path => ":rails_root/public/assets/drawings/:id/:basename.:extension",
  #                  :keep_old_files => true # this is from Alain Ravet's paperclip fork: http://github.com/goncalossilva/paperclip/  
  
end
