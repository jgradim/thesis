class DocumentItem

  include ClassLevelInheritableAttributes
  inheritable_attributes :default_values
  @default_values = {}

  def initialize(params = {})
    self.class.default_values.merge(params).each do |k,v|
      self.send("#{k}=", v)
    end
  end
  
  # setter for default values
  def self.defaults(d = {})
    self.default_values = d
  end
  
end
