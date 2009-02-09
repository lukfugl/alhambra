When "$actor creates an? $event_type event" do |actor, event_type|
  start_event(event_type)
end

When "$actor sets the event $attribute to '$value'" do |actor, attribute, value|
  set_event_attribute(attribute, value)
end

When "$actor doesn't set the event $attribute" do |actor, attribute|
  clear_event_attribute(attribute)
end

When "$actor posts the event to $resource" do |actor, resource|
  post decode_resource(resource), event_representation
end

When "$actor goes to $resource" do |actor, resource|
  get decode_resource(resource)
end

Then "the response should have status $status" do |status|
  response.status.should eql(status)
end
