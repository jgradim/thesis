class Block < ActiveRecord::Base

  belongs_to :document, :touch => true
  acts_as_list :scope => :document

  def initialize(attributes = nil)
    super(attributes)
    @_item = self.item rescue attributes[:content]
  end

  # use to create blocks and set the build_id
  # blocks should only be created using this method
  def self.make(params)

    Block.transaction do
      block_params = { :document_id => params[:document_id] }
      item_params  = params[:block]

      block = nil
      Document.without_version do
        block = Block.create(block_params)
      end

      block.build_item(item_params)
      block.save!

      block.reload
    end
  end

  def build_item(params)
    item = params[:type].classify.constantize.new(params[:params])
    item.block_id = self.id
    item.store_attachments
    @_item = item
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
    Block.delete(self.id)
    d.reload.save!
  end

  # AR Callbacks
  before_save :serialize_content

  def serialize_content
    self.content = @_item.to_json if @_item.is_a?(Serializable)
  end


end
