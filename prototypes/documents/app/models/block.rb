class Block < ActiveRecord::Base

  belongs_to :document, :touch => true
  acts_as_list :scope => :document
  
  def item
    j = JSON.parse(self.content)
    DocumentItem.from_json(j)
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
      self.content = self.content.to_json
    end
  end
  
  def save_document
    self.document.reload.save!
  end
  
end
