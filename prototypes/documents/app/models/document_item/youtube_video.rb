class DocumentItem::YoutubeVideo < DocumentItem

  attr_accessor :video_id
  
  validates :video_id, /youtube\.com\/watch\?v=([A-Za-z0-9._%-]*)[&\w;=\+_\-]*/

end
