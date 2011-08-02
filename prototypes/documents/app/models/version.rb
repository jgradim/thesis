class Version < ActiveRecord::Base

  #
  ## FINDER METHODS
  def self.one_for(obj, version)
    self.find(:first, :conditions => ['obj_type = ? AND obj_id = ? AND version = ?', obj.class.to_s, obj.id, version])
  end

  def self.all_for(obj)
    self.find(:all, :conditions => ['obj_type = ? AND obj_id = ?', obj.class.to_s, obj.id], :order => 'version ASC')
  end

  def self.head_for(obj)
    self.find(:first, :conditions => ['obj_type = ? AND obj_id = ?', obj.class.to_s, obj.id], :order => 'version DESC')
  end

  # manipulation methods
  def object
    CallableHash.new(raw_object)
  end
  
  def raw_object
    JSON.parse(content)
  end

end
