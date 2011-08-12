module Memento #:nodoc:

  VERSION             = "0.0.1"
  EXCLUDE_FROM_REVERT = %w(id created_at updated_at)
  CALLBACKS           = [:create_version, :create_version_for_associations]

  module ClassMethods

    attr_reader :versioned_associations, :triggered_associations, :dont_keep_memento

    def memento_includes(*associations)
      @versioned_associations = associations.compact.uniq || []
    end

    def triggers_memento_in(*associations)
      @triggered_associations = associations.compact.uniq || []
    end

    #
    # Allows saving a version without creating a memento
    #
    ##
    def without_version(&block)
      class_eval do
        CALLBACKS.each do |callback_name|
          alias_method "orig_#{callback_name}".to_sym, callback_name
          alias_method callback_name, :noop
        end
      end

      yield

    ensure
      class_eval do
        CALLBACKS.each do |callback_name|
          alias_method callback_name, "orig_#{callback_name}".to_sym
        end
      end
    end

    def does_not_keep_memento
      @dont_keep_memento = true
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

    def revert(v)
      item_version = self.version(v) or return false

      # select all attributes for
      attributes = item_version.raw_object[self.class.to_s.downcase].except(*self.class.versioned_associations.map(&:to_s), *Versioned::EXCLUDE_FROM_REVERT)

      # revert associations alongside
      # each association creates its own new version, but don't trigger in "parent" class
      if self.class.versioned_associations
        self.class.without_version do
        end
      end
      self.update_attributes(attributes)
    end

    def create_version_for_associations
      self.class.triggered_associations.each do |association|
        if self.send(association).is_a?(Array)
          self.send(association).each(&:create_version)
        else
          self.send(association).create_version
        end
      end
    end

    #
    ##
    def create_version

      return true if self.class.dont_keep_memento

      new_version_number = self.head.version + 1 rescue 1
      serialized_object  = self.to_json(:include => self.class.versioned_associations)

      Version.create(:obj_id => self.id, :obj_type => self.class.to_s, :content => serialized_object, :version => new_version_number)
    end

    #
    ##
    def noop
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.send(:after_save, :create_version)
    receiver.send(:after_save, :create_version_for_associations)
    receiver.send(:memento_includes, nil)
    receiver.send(:triggers_memento_in, nil)
  end

end
