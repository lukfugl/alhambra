# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatters/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.use_transactional_fixtures

require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

# Comment out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
require 'webrat/rspec-rails'

module StatefulWorld
  def save_object(name, object)
    @objects ||= {}
    @objects[name] = object
  end

  def get_object(name)
    @objects ||= {}
    @objects[name]
  end

  def decode_resource(resource)
    case resource
    when "the lobby feed", "the lobby"
      "lobby"
    when /^the URI for (.*)$/
      object = get_object($1)
      uri_for(object)
    else
      resource
    end
  end

  def uri_for(object)
    case object
    when Game
      game_path(:id => object)
    else
      raise "Don't know how to build URIs for #{object.class} objects"
    end
  end

  def start_event(type)
    @event_type = type
    @event_data = {}
  end

  def set_event_attribute(attribute, value)
    @event_type.should_not be_nil
    @event_data[attribute] = value
  end

  def clear_event_attribute(attribute)
    @event_type.should_not be_nil
    @event_data.delete(attribute)
  end

  def event_representation
    @event_type.should_not be_nil
    { @event_type => (@event_data.empty? ? nil : @event_data) }.to_yaml
  end
end

World do |world|
  returning world do |w|
    w.extend(StatefulWorld)
  end
end
