Given "there are some number of $objects" do |objects|
  count_objects(objects)
end

Then "there should be another $object" do |object|
  another_object?(object)
end

Then "there should not be another $object" do |object|
  no_more_objects?(object)
end

Then "$object should have $attribute '$value'" do |object, attribute, value|
  get_object(object).send(attribute).should eql(value)
end

Given "an? $object \\($name\\) exists" do |object, name|
  create_object(name, object)
end
