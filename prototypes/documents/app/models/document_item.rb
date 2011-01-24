class DocumentItem

  include ActiveModel::Serialization

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
  
  # builder method
  def self.from_json(j)
    j.first.first.constantize.new(j.first.last)
  end
  
  # serialize object in JSON, with root, like in AR to_json 
  def serialize
    "{\"#{self.class.to_s}\":#{self.to_json}}"
  end
  
  # setter for default values
  def self.defaults(attribute, value)
    self.default_values.merge!({attribute => value})
  end
  
  # setter for validations
  def self.validates(attribute, rule)
    self.validations.merge!({attribute => rule})
  end
  
end
