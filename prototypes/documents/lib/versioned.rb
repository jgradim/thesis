module Versioned

  module ClassMethods

    attr_accessor :vam, :va
    @vam = [:has_many]
    @va  = []

    def versioned_association_macros(*macros)
      @vam = macros
    end
    
    def versioned_associations(*associations)
      @va = associations
    end
  end

  module InstanceMethods

    #
    ##
    def version(v)
      Version.one_for(self, v)
    end

    def versions
      Version.all_for(self)
    end

    def head
      Version.head_for(self)
    end

    def revert(version)
      # TODO
    end

    #
    ##
    def create_version
      # select all has_many associations in order to serialize along with itself
      associations       = self.class.reflect_on_all_associations.select{ |a| self.class.vam.include?(a.macro) }.map(&:name)
      new_version_number = self.head.version + 1 rescue 1
      serialized_object  = self.to_json(:include => associations)

      #Version.create(:obj_id => self.id, :obj_type => self.class.to_s, :content => serialized_object, :version => new_version_number)
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.send(:after_save, :create_version)
    receiver.send(:versioned_association_macros, :has_many)
    receiver.send(:versioned_associations, nil)
  end
end
