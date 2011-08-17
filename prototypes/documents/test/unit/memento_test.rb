require File.expand_path('../../test_helper', __FILE__)

class MementoTest < ActiveSupport::TestCase

  test "version creation" do

    doc = Document.create :title => 'test'

    assert_equal doc.versions.size, 1, "Document should have 1 version"
    assert_equal doc.head.version,  1, "Document head version should equal 1"

    b1 = doc.blocks.create :content => Serializable::Paragraph.new(:title => 'Paragraph 1');
    b2 = doc.blocks.create :content => Serializable::Paragraph.new(:title => 'Paragraph 2');
    b3 = doc.blocks.create :content => Serializable::Paragraph.new(:title => 'Paragraph 3');

    assert_equal doc.versions.size, 4, "Document should have 4 version"
    assert_equal doc.head.version,  4, "Document head version should equal 4"

    Document.without_version do
      b3.item.title = 'Paragraph 3, no new version!'
      b3.save
    end

    assert_equal doc.versions.size, 4, "Document should have 4 version"
    assert_equal doc.head.version,  4, "Document head version should equal 4"
    assert_equal doc.blocks.last.item.title, "Paragraph 3, no new version!", "Last block content should be modified"
  end


end
