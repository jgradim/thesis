class DocumentItem

  include ClassLevelInheritableAttributes
  inheritable_attributes :default_values, :validations
  @default_values = {}
  @validations = {}

  def initialize(params = {})
  
    self.class.default_values.merge(params).each do |k,v|
      self.send("#{k}=", v)
    end
    
    self.class.validations.each do |k,v|
      throw "invalid value for '#{k}': #{v.inspect}" if not self.send("#{k}") =~ v
    end
    
  end
  
  # setter for default values
  def self.defaults(dv = {})
    self.default_values.merge!(dv)
  end
  
  # setter for validations
  def self.validates(v = {})
    self.validations.merge!(v)
  end
  
end
