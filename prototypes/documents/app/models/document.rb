class Document < ActiveRecord::Base

  has_many :blocks, :order => "position"
  include Versioned
  
  # AR Callbacks
  #after_save :create_version
  #
  #def create_version
  #  self_with_blocks = self.to_json(:include => :blocks)
  #  version = self.head.version + 1 rescue 1
  #  Version.create(:obj_id => id, :obj_type => self.class.to_s, :content => self_with_blocks, :version => version)
  #end
  
end
