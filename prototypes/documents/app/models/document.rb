class Document < ActiveRecord::Base

  has_many :blocks, :order => "position"
  
  def versions
    Version.find(:all,
      :conditions => ['obj_id = ? AND obj_type = ?', self.id, self.class.to_s],
      :order => 'version ASC')
  end
  
  # AR Callbacks
  after_save :create_version
  
  def create_version
    self_with_blocks = YAML.dump(Document.find(self.id, :include => :blocks))
    version = self.versions.last.version + 1 rescue 1
    Version.create(:obj_id => id, :obj_type => self.class.to_s, :content => self_with_blocks, :version => version)
  end
  
end
