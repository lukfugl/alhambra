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
  def save_object(name, instance)
    instance.should_not be_nil
    @objects ||= {}
    @objects[name] = instance
  end

  def create_object(name, type, params={})
    save_object(name, model_for(type).create(params))
  end

  def get_object(name)
    @objects ||= {}
    @objects[name].should_not be_nil
    @objects[name]
  end

  def decode_resource(resource)
    case resource
    when "the lobby feed", "the lobby"
      "lobby"
    when /^the URI for (.*)$/
      instance = get_object($1)
      uri_for(instance)
    else
      resource
    end
  end

  def uri_for(instance)
    case instance
    when Game
      game_path(:id => instance)
    else
      raise "Don't know how to build URIs for #{instance.class} objects"
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

  def count_objects(type)
    model = model_for(type)
    @counts ||= {}
    @counts[model] = model.count
    @counts[model]
  end

  def more_objects?(type, n)
    model = model_for(type)
    @counts[model].should_not be_nil
    expected_count = @counts[model] + n
    count_objects(type).should equal(expected_count)
  end

  def another_object?(type)
    if type =~ /^(.*?) \((.*?)\)$/
      type, name = $1, $2
    end

    more_objects?(type, 1)

    instance = model_for(type).find(:first, :order => 'created_at DESC')
    instance.should_not be_nil

    save_object(name, instance) if name
  end

  def no_more_objects?(type)
    model = model_for(type)
    expected_count = @counts[model]
    count_objects(type).should equal(expected_count)
  end

  def model_for(type)
    type.classify.constantize
  end
end

World do |world|
  returning world do |w|
    w.extend(StatefulWorld)
  end
end
