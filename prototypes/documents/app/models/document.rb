class Document < ActiveRecord::Base

  has_many :blocks, :order => "position"

  include Versioned
  include_in_versioning :blocks

end
