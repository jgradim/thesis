class Block < ActiveRecord::Base

  #DocumentItem.class
  #DocumentItem::Paragraph.class

  belongs_to :document
  acts_as_list :scope => :document
  
  #alias_method :yamled_content, :content # <= does not work, tries to alias Block.content instead of @block.content
  def item
    Marshal.load(content.force_encoding('US-ASCII'))
  end
  
  before_save :yaml_content
  def yaml_content
    self.content = Marshal.dump(self.content) rescue nil
  end
end
