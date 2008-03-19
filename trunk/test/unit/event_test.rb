require File.dirname(__FILE__) + '/../test_helper'

class EventTest < ActiveSupport::TestCase
  def test_event_data_delegation_accessors
    event_class = Class.new(Event)
    data = { :foo => 1, :bar => 2 }
    event_class.class_eval{ event_data *data.keys }
    event = event_class.new(data)
    assert_equal data, event.event_data
    assert_equal 1, event.foo
    assert_equal 2, event.bar

    event.save
    loaded_event = event_class.find(event.id)
    assert_equal data, loaded_event.event_data
    assert_equal 1, loaded_event.foo
    assert_equal 2, loaded_event.bar
  end
end
