module StatePattern
  module ActiveRecord
    def self.included(base)
      base.class_eval do
        include StatePattern
        include StatePatternOverrides
        extend ClassMethods

        after_initialize :set_state_from_db
        #enable after_initialize callback
        if Rails.version >= "3.0.0"
          def self.after_initialize; end
        else
          def after_initialize; end
        end

      end
    end

    module ClassMethods
      def state_attribute
        @state_attribute ||= "state"
      end

      def set_state_attribute(state_attr)
        @state_attribute = state_attr.to_s
      end
    end

    module StatePatternOverrides
      def set_state(state_class)
        super
        write_attribute(self.class.state_attribute, @current_state_instance.class.name)
      end
    end

    def set_state_from_db
      stored_value = send(self.class.state_attribute)
      set_state(state_string_as_class(stored_value) || self.class.initial_state_class)
    end

    def current_state=(new_state_string)
      set_state(state_string_as_class(new_state_string))
    end

    def state_string_as_class(state_string)
      state_string.camelize.constantize unless state_string.nil?
    end

  end
end

