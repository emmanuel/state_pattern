module StatePattern
  class State

    def self.state_methods
      public_instance_methods - State.public_instance_methods
    end

    attr_reader :stateful, :previous_state

    def initialize(stateful, previous_state)
      @stateful = stateful
      @previous_state = previous_state
      enter
    end

    def state_name
      self.class.name
    end

    def transition_to(state_class)
      @stateful.transition_to(state_class)
    end

    def enter
    end

    def exit
    end
  end
end
