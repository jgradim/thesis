class Block < ActiveRecord::Base

  belongs_to :document, :touch => true
  acts_as_list :scope => :document

  def initialize
    super
    @item = item
  end

  def item
    j = JSON.parse(self.content)
    Serializable.from_json(j)
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

  def serialize_content
    if self.content and not self.content.is_a?(String)
      self.content = self.content.to_json
    end
  end

end
