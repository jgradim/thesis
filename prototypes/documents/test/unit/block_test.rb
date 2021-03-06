require File.expand_path('../../test_helper', __FILE__)

class BlockTest < ActiveSupport::TestCase

  test "item access and modification" do

    b = Block.create :content => Serializable::Paragraph.new(:content => "oh yeah, I'm a Paragraph")

    assert_equal b.item.content, "oh yeah, I'm a Paragraph"

    # test direct object manipulation from #block
    b.item.content = 'oh noes'
    assert_equal b.item.content, 'oh noes'
    b.save!
    assert_equal b.item.content, 'oh noes'

    b = Block.last
    assert b.content.is_a? String
    assert Serializable.from_json(b.content).is_a?(Serializable::Paragraph)
    assert b.item.is_a? Serializable::Paragraph
    assert_equal b.item.content, 'oh noes'

  end

  test "versions creation and #block.item.block_id with Block#make method" do

    d = Document.create :title => 'test document'

    assert_equal d.versions.size, 1, "Document should have 1 version"
    assert_equal d.head.version,  1, "Document head version should be 1"

    b = d.blocks.make({ :document_id => d.id, :block => {:type => "serializable/drawing", :params => {}} })

    d = d.reload

    assert_equal d.versions.size, 2, "Document should have 2 versions"    # Block.build should only create 1 version in the document
    assert_equal d.head.version,  2, "Document head version should be 2"  # but set the right block_id in its item

    assert_equal b.id, b.item.block_id, "Block and item should have the same id"

  end

  test "attachments in Serializable objects" do

    d = Document.create :title => 'test document'
    b = d.blocks.make({ :document_id => d.id, :block => {:type => "serializable/drawing", :params => {}} })

    # try to upload an invalid file
    b.item.image = File.open('config/environment.rb')
    b.item.image.store!
    assert_nil b.item.image.url

    # try to upload a valid file
    b.item.image = File.open('public/images/rails.png')
    b.item.image.store!
    assert_not_nil b.item.image.url

  end

end
