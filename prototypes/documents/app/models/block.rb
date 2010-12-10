class Block < ActiveRecord::Base

  belongs_to :document
  acts_as_list :scope => :document
  
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
  
  # we can't have @block.destroy calling after_save callbacks, it would mess up
  # the versions creation
  def destroy
    d = self.document
    self.delete
    d.reload.save!
  end
  
  # AR Callbacks
  before_save :serialize_content
  after_save :save_document
  
  def serialize_content
    if self.content and not self.content.is_a?(String)
      self.content = YAML.dump(self.content) rescue nil
    end
  end
  
  def save_document
    self.document.reload.save!
  end
  
end
