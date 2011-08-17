class Block < ActiveRecord::Base

  belongs_to :document, :touch => true
  acts_as_list :scope => :document

  def initialize(attributes = nil)
    super(attributes)
    @_item = self.item rescue attributes[:content]
  end

  # use to create blocks and set the build_id
  # blocks should only be created using this method
  def self.make(attributes)
    block = nil
    Document.without_version do
      block = Block.create(attributes)
    end
    if block.item
      block.item.block_id = block.id
      block.save
    end
    block.reload
  end

  def item
    return @_item if @_item
    j = JSON.parse(self.content)
    @_item = Serializable.from_json(j)
  end
  def item=(item)
    self.content = item.to_json
    @_item = item
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
    self.content = @_item.to_json if @_item.is_a?(Serializable)
  end


end
