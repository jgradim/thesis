class DocumentItem

  include InheritableTraits
  traits :default_values, :validations

  def initialize(params = {})
  
    self.class.default_values.merge(params).each do |k,v|
      v.map!{ |o|
        if o.is_a?(Hash) and o.try(:first).try(:first) =~ /DocumentItem/
          DocumentItem.from_json(o)
        else
          o
        end
      } if v.is_a?(Array)
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
  
  # setter for default values
  def self.defaults(attribute, value)
    self.default_values.merge!({attribute => value})
  end
  
  # setter for validations
  def self.validates(attribute, rule)
    self.validations.merge!({attribute => rule})
  end

  # serialize with class name so object can be rebuilt
  def to_json(*args, &block)
    "{\"#{self.class}\": #{super}}"
  end
  
  # initialize inheritable traits
  def self.inherited(subclass)
    subclass.default_values ||= {}
    subclass.validations ||= {}
  end
  
end
