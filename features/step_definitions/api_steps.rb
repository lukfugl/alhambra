When "$actor creates an? $event_type event" do |actor, event_type|
  @event_type = event_type
  @event = nil
end

When "$actor sets the event $attribute to '$value'" do |actor, attribute, value|
  @event_type.should_not be_nil
  @event_data ||= {}
  @event_data[attribute] = value
end

When "$actor doesn't set the event $attribute" do |actor, attribute|
  @event_type.should_not be_nil
  if @event_data && @event_data.has_key?(attribute)
    @event_data.delete(attribute)
    if @event_data.empty?
      @event_data = nil
    end
  end
end

When "$actor posts the event to $resource" do |actor, resource|
  @event_type.should_not be_nil
  post decode_resource(resource), { @event_type => @event_data }.to_yaml
end

When "$actor goes to $resource" do |actor, resource|
  get decode_resource(resource)
end

Then "the response should have status $status" do |status|
  response.status.should eql(status)
end
