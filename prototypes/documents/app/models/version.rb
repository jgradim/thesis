class Version < ActiveRecord::Base

  def object
    CallableHash.new(raw_object)
  end
  
  def raw_object
    JSON.parse(content)
  end

end
