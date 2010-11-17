# coding: utf-8

require './test_helper'

class DocumentTest < ActiveSupport::TestCase

  test "marshalling" do
  
    @doc = Document.create(:title => 'Test Document')
    
    @b1 = @doc.blocks.create :content => Paragraph.new("isto é um paragrafo do bloco 1")
    @b2 = @doc.blocks.create :content => Paragraph.new("isto é um paragrafo do bloco 2")
    @b3 = @doc.blocks.create :content => Paragraph.new("isto é um paragrafo do bloco 3")
    
    assert_size @doc.blocks.size, 3
  
  end
  
end
