# http://wiseheartdesign.com/articles/2006/09/22/class-level-instance-variables/
module InheritableTraits

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def traits(*attrs)
      @traits ||= []
      @traits += attrs
      attrs.each do |attr|
        class_eval %{
          def self.#{attr}(string = nil)
            @#{attr} = string || @#{attr}
          end
          def self.#{attr}=(string = nil)
            #{attr}(string)
          end
        }
      end
      @traits
    end

    def inherited(subclass)
      (["traits"] + traits).each do |t|
        ivar = "@#{t}"
        subclass.instance_variable_set(
          ivar,
          instance_variable_get(ivar)
        )
      end
      super # fixes "can't dup NilClass error" as AR::Base also defines `included'
    end
  end

end
