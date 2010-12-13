require 'state_pattern/active_record/test_helper'

class ARButton < ActiveRecord::Base
  class On < StatePattern::State
    def press
      transition_to(Off)
      "#{stateful.button_name} is off"
    end
  end

  class Off < StatePattern::State
    def press
      transition_to(On)
      "#{stateful.button_name} is on"
    end
  end

  include StatePattern::ActiveRecord
  set_initial_state Off

  def button_name
    "The button"
  end
end

class ARButton2 < ARButton
  set_state_attribute :state2
  set_initial_state ARButton::Off
end

Expectations do
  expect "ARButton::Off" do
    ARButton.create.state
  end

  expect "The button is on" do
    button = ARButton.create
    button.press
  end

  expect "ARButton::On" do
    button = ARButton.create
    button.press
    button.state
  end

  expect "The button is off" do
    button = ARButton.create
    button.current_state = "ARButton::On"
    button.press
  end

  expect "The button is off" do
    button = ARButton.create
    button.press
    button.press
  end

  expect "ARButton::On" do
    ARButton.create(:current_state => "ARButton::On").state
  end

  expect nil do
    ARButton2.create.state
  end

  expect "ARButton::Off" do
    ARButton2.create.state2
  end
end
