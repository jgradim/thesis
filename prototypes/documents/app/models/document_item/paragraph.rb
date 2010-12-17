class DocumentItem::Paragraph < DocumentItem
  
  attr_accessor :content
  
  defaults :content => ""
  
  validates :content => /^a.*b$/
  
end
