module Memento #:nodoc:

  VERSION             = "0.0.1"
  EXCLUDE_FROM_REVERT = %w(id created_at updated_at)
  CALLBACKS           = [:create_version, :setup_callbacks_for_triggered_associations]

  module ClassMethods

    attr_reader :versioned_associations, :triggered_associations, :dont_keep_memento

    #
    # CONFIGURATION CLASS METHODS
    #
    ############################################################################
    def memento_includes(*associations)
      @versioned_associations = associations.compact.uniq || []
    end

    def triggers_memento_in(*associations)
      @triggered_associations = associations.compact.uniq || []
    end

    def does_not_keep_memento
      @dont_keep_memento = true
    end

    #
    # Allows saving a version without creating a memento
    #
    ############################################################################
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

  end

  module InstanceMethods

    #
    # ATTRIBUTE-LIKE METHODS
    #
    ############################################################################

    def version(v)
      Version.one_for(self, v)
    end

    def versions
      Version.all_for(self)
    end

    def head
      Version.head_for(self)
    end

    #
    # MANIPULATION METHODS
    #
    ############################################################################

    def revert(v)
      item_version = self.version(v) or return false

      # revert associations alongside
      # each association creates its own new version, but don't trigger in "parent" class
      self.class.versioned_associations.each do |versioned_association|

        versioned_association_objects = item_version.raw_object[self.class.to_s.downcase][versioned_association.to_s]

        self.class.without_version do
          # STUB: try to find objects, create them if not. However, what to do if some exist and others don't?

          # current_ids & versioned_ids
          current_ids   = self.send(versioned_association).map(&:id)
          versioned_ids = versioned_association_objects.map{ |o| o['id'] }

          ids_to_keep   = current_ids & versioned_ids
          ids_to_delete = current_ids - ids_to_keep
          ids_to_create = versioned_ids - current_ids

          versioned_association_class = versioned_association.to_s.classify.constantize

          # delete associated objects
          versioned_association_class.find(ids_to_delete).map(&:destroy)

          # modify associated_objects
          ids_to_keep.each do |id|
            to_keep = versioned_association_objects.select{ |o| o["id"] == id }.first.except(*Memento::EXCLUDE_FROM_REVERT)

            #
            obj = versioned_association_class.find(id)
            if obj.respond_to?(:revert)
              obj.revert(v)
            else
              obj.update_attributes(to_keep)
            end
          end

          # create associated objects
          ids_to_create.each do |id|
            to_create = versioned_association_objects.select{ |o| o["id"] == id }.first.except(*Memento::EXCLUDE_FROM_REVERT)

            self.send(versioned_association).send(:create, to_create).inspect
          end
        end
      end

      # select all attributes for reverting the values to the desired version
      attributes = item_version.raw_object[self.class.to_s.downcase].except(*self.class.versioned_associations.map(&:to_s), *Memento::EXCLUDE_FROM_REVERT)
      self.update_attributes(attributes)

    end

    #
    # CALLBACK METHODS
    #
    ############################################################################

    def create_version

      return true if self.class.dont_keep_memento

      new_version_number = self.head.version + 1 rescue 1
      serialized_object  = self.to_json(:include => self.class.versioned_associations)

      Version.create(:obj_id => self.id, :obj_type => self.class.to_s, :content => serialized_object, :version => new_version_number)
    end

    def setup_callbacks_for_triggered_associations
      self.class.triggered_associations.each do |association|
        if self.send(association).is_a?(Array)
          self.send(association).each(&:create_version)
        else
          self.send(association).create_version
        end
      end
    end

    #
    # HELPER METHODS
    #
    ############################################################################

    def noop
    end

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.send(:after_save, :create_version)
    receiver.send(:after_save, :setup_callbacks_for_triggered_associations)
    receiver.send(:memento_includes, nil)
    receiver.send(:triggers_memento_in, nil)
  end

end
