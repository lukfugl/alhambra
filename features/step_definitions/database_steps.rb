Given("there are some number of $objects") do |objects|
  object = objects.singularize
  model = object.classify.constantize
  @counts ||= {}
  @counts[object] = model.count
end

Then("there should be $n more $objects") do |n, objects|
  object = objects.singularize
  model = object.classify.constantize
  model.count.should equal(@counts[object] + n.to_i)
end

Then("there should be $n fewer $objects") do |n, objects|
  object = objects.singularize
  model = object.classify.constantize
  model.count.should equal(@counts[object] - n.to_i)
end

Given "no $object with $attribute '$value' exists" do |object, attribute, value|
  model = object.classify.constantize
  model.destroy_all(attribute => value)
  model.send("find_by_#{attribute}", value).should be_nil
end

Then "an? $object with $attribute '$value' should exist" do |object, attribute, value|
  model = object.classify.constantize
  instance = model.send("find_by_#{attribute}", value)
  instance.should_not be_nil
  @instances ||= {}
  @instances[object] = instance
end
