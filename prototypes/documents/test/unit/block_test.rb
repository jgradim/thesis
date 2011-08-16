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


end
