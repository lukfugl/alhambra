Given "there are some number of $objects" do |objects|
  object = objects.singularize
  model = object.classify.constantize
  @counts ||= {}
  @counts[object] = model.count
end

Then "there should be another $object" do |object|
  model = object.classify.constantize
  model.count.should equal(@counts[object] + 1)
  instance = model.find(:first, :order => 'created_at DESC')
  instance.should_not be_nil
  @new_instances ||= {}
  @new_instances[object] = instance
end

Then "the new $object should have $attribute '$value'" do |object, attribute, value|
  model = object.classify.constantize
  instance = @new_instances[object]
  instance.should_not be_nil
  instance.send(attribute).should eql(value)
end
