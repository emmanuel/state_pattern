require 'forwardable'
require 'state_pattern/state'

module StatePattern
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    attr_reader :initial_state_class

    def set_initial_state(state_class)
      @initial_state_class = state_class
      include ::StatePattern::Delegation
    end
  end

  module Delegation
    extend Forwardable

    def self.included(base)
      def_delegators :current_state_instance, *base.initial_state_class.state_methods
    end
  end

  def current_state_instance
    enter_state(self.class.initial_state_class) if @current_state_instance.nil?
    @current_state_instance
  end

  def set_state(state_class)
    return @current_state_instance if @current_state_instance.class == state_class
    @current_state_instance = state_class.new(self, @current_state_instance)
  end

  def enter_state(next_state_class)
    set_state(next_state_class)
    current_state_instance.enter
  end

  def transition_to(next_state_class)
    current_state_instance.exit
    enter_state(next_state_class)
  end
end

require 'state_pattern/active_record' if defined? ActiveRecord::Base
