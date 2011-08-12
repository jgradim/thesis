module Versioned

  EXCLUDE_FROM_REVERT = %w(id created_at updated_at)

  module ClassMethods

    attr_reader :versioned_associations, :triggered_associations

    def include_in_versioning(*associations)
      @versioned_associations = associations.compact.uniq || []
    end

    def trigger_version_in(*associations)
      @triggered_associations = associations.compact.uniq || []
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
      new_version_number = self.head.version + 1 rescue 1
      serialized_object  = self.to_json(:include => self.class.versioned_associations)

      Version.create(:obj_id => self.id, :obj_type => self.class.to_s, :content => serialized_object, :version => new_version_number)
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.send(:after_save, :create_version)
    receiver.send(:include_in_versioning, nil)
  end

end
