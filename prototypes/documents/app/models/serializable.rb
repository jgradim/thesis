class Serializable

  attr_accessor :block_id # used for file attachments

  include InheritableTraits
  traits :default_values, :validations

  def initialize(params = {})

    self.class.default_values.merge(params).each do |k,v|

      # nested Serializable:: objects
      v.map!{ |o|
        if o.is_a?(Hash) and o.try(:first).try(:first) =~ /Serializable/
          Serializable.from_json(o)
        else
          o
        end
      } if v.is_a?(Array)

      # runtime instead of loadtime evaluations (i18n, current time, etc)
      v = v.call if v.is_a?(Proc)

      self.send("#{k}=", v)
    end

    self.class.validations.each do |k,v|
      unless self.send("#{k}") =~ v
        raise Serializable::Exceptions::InvalidValue.new("invalid value '#{self.send(k).inspect}' for '#{k}'")
      end
    end

  end

  # builder method
  def self.from_json(j)
    j = JSON.parse(j) if j.is_a?(String)
    j.first.first.constantize.new(j.first.last)
  end

  # reference to AR models
  # automatically creates attr_accessor and methods for retrieval
  def self.references_ar(*models)
    models.each do |ar_model|
      foreign_key = "#{ar_model.to_s}_id".to_sym
      class_eval do
        attr_accessor foreign_key
        define_method ar_model do
          ar_model.to_s.classify.constantize.find(instance_variable_get("@#{foreign_key.to_s}"))
        end
      end
    end
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
    # Remove the @_mounters instance var added by CarrierWave (0.4.1 atm),
    # which contains circular references :(
    "{\"#{self.class}\": #{instance_values.except('_mounters').to_json}}"
  end

  # initialize inheritable traits
  def self.inherited(subclass)
    subclass.default_values ||= {}
    subclass.validations ||= {}
  end

  # exception classes
  module Exceptions
    class InvalidValue < Exception; end
  end

end
