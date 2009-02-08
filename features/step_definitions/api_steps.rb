def load_event(type, name)
  event_fixture_path = File.expand_path(File.dirname(__FILE__) + "/../event_fixtures/#{type.underscore}/#{name}")
  File.read(event_fixture_path)
end

def decode_resource(resource)
  case resource
  when "the lobby feed"
    "lobby"
  else
    resource
  end
end

When("$actor posts the $type event in $name to $resource") do |actor, type, name, resource|
  post decode_resource(resource), load_event(type, name)
end
