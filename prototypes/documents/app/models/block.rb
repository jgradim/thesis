class Block < ActiveRecord::Base

  belongs_to :document
  acts_as_list :scope => :document
  
  #alias_method :yamled_content, :content # <= does not work, tries to alias Block.content instead of @block.content
  def item 
    i = YAML.load(content)
    if i.class.is_a?(String)
      i.class.constantize
      return YAML.load(content)
    end
    i
  end
  def item=(item)
    self.content = item
  end
  
  # AR Callbacks
  before_save :serialize_content
  after_save :save_document
  
  def serialize_content
    self.content = YAML.dump(self.content) rescue nil
  end
  
  def save_document
    self.document.save!
  end
end
