class Document < ActiveRecord::Base

  has_many :blocks, :order => "position"
  
end
