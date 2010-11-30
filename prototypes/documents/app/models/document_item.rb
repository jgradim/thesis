class DocumentItem

  include ClassLevelInheritableAttributes
  inheritable_attributes :defaults
  @defaults = {}

  def initialize(params = {})
    self.class.defaults.merge(params).each do |k,v|
      self.send("#{k}=", v)
    end
  end
  
end
