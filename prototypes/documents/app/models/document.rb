class Document < ActiveRecord::Base

  has_many :blocks, :order => "position"

  include Memento
  memento_includes :blocks

end
