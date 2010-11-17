class Block < ActiveRecord::Base

  belongs_to :document
  acts_as_list :scope => :document
  
  #alias_method :yamled_content, :content # <= does not work, tries to alias Block.content instead of @block.content
  def item
    YAML.load(content)
  end
  def item=(item)
    self.content = item
  end
  
  # AR Callbacks
  before_save :yaml_content
  after_save :save_document
  
  def yaml_content
    self.content = YAML.dump(self.content) rescue nil
  end
  
  def save_document
    self.document.save!
  end
end
