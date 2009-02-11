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
  post decode_name(resource), event_representation
end

When "$actor goes to $resource" do |actor, resource|
  get decode_name(resource)
end

Then "the response should have status $status" do |status|
  response.status.should eql(status)
end

Then "$actor should see a $type representation" do |actor, type|
  Then "the response should have status 200 OK"
  save_representation(response.body, type)
end

Then "that representation should include $something" do |something|
  something = decode_name(something)
  representation = get_representation
  representation.class.should equal(Array)
  representation.should include(something)
end

Then "that representation's $attribute should be $something" do |attribute, something|
  something = decode_name(something)
  representation = get_representation
  representation.class.should equal(Hash)
  representation[attribute].should eql(something)
end
