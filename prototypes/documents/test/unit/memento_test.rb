require File.expand_path('../../test_helper', __FILE__)

class MementoTest < ActiveSupport::TestCase

  test "version creation" do

    doc = Document.create :title => 'test'

    assert_equal doc.versions.size, 1, "Document should have 1 version"
    assert_equal doc.head.version,  1, "Document head version should equal 1"

    b1 = doc.blocks.make({ :document_id => doc.id, :block => {:type => "serializable/paragraph", :params => { :title => 'Paragraph 1' } } })
    b2 = doc.blocks.make({ :document_id => doc.id, :block => {:type => "serializable/paragraph", :params => { :title => 'Paragraph 2' } } })
    b3 = doc.blocks.make({ :document_id => doc.id, :block => {:type => "serializable/paragraph", :params => { :title => 'Paragraph 3' } } })

    assert_equal doc.versions.size, 4, "Document should have 4 version"
    assert_equal doc.head.version,  4, "Document head version should equal 4"

    Document.without_version do
      b3.item.title = 'Paragraph 3, no new version!'
      b3.save
    end

    assert_equal doc.versions.size, 4, "Document should have 4 version"
    assert_equal doc.head.version,  4, "Document head version should equal 4"
    assert_equal doc.reload.blocks.last.item.title, "Paragraph 3, no new version!", "Last block content should be modified"
  end

  test "revert to version" do

    d = Document.create :title => 'to revert'                                                                                            # v = 1

    b1 = d.blocks.make({ :document_id => d.id, :block => {:type => "serializable/paragraph", :params => { :title => 'Paragraph 1' } } }) # v = 2
    b2 = d.blocks.make({ :document_id => d.id, :block => {:type => "serializable/paragraph", :params => { :title => 'Paragraph 2' } } }) # v = 3
    b3 = d.blocks.make({ :document_id => d.id, :block => {:type => "serializable/paragraph", :params => { :title => 'Paragraph 3' } } }) # v = 4

    b2.destroy                                                                                                                           # v = 5

    assert_equal d.versions.size, 5
    assert_equal d.reload.blocks.map(&:id), [b1.id, b3.id]

    b4 = d.blocks.make({ :document_id => d.id, :block => {:type => "serializable/paragraph", :params => { :title => 'Paragraph 4' } } }) # v = 6

    d.title = 'zomgwtfbbq'
    d.save!                                                                                                                              # v = 7

    assert_equal d.reload.versions.size, 7

    d.reload.revert(4)                                                                                                                   # v = 8

    assert_equal d.reload.versions.size, 8, "after revert, version should increase by 1"
    assert_equal d.reload.title, 'to revert', "after revert, attributes should change"
    assert_equal d.reload.blocks.size, 3, "After revert document should have 3 blocks again"

    assert_equal Version.count, 8

  end

end
