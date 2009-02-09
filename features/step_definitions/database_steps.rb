Given "there are some number of $objects" do |objects|
  object = objects.singularize
  model = object.classify.constantize
  @counts ||= {}
  @counts[object] = model.count
end

Then "there should be another $object" do |object|
  if object =~ /^(.*?) \((.*?)\)$/
    object, name = $1, $2
  end

  model = object.classify.constantize
  model.count.should equal(@counts[object] + 1)
  @counts[object] = model.count

  instance = model.find(:first, :order => 'created_at DESC')
  instance.should_not be_nil

  if name
    save_object(name, instance)
  end
end

Then "there should not be another $object" do |object|
  model = object.classify.constantize
  model.count.should equal(@counts[object])
end

Then "$object should have $attribute '$value'" do |object, attribute, value|
  instance = get_object(object)
  instance.should_not be_nil
  instance.send(attribute).should eql(value)
end

Given "an? $object \\($name\\) exists" do |object, name|
  model = object.classify.constantize
  instance = model.create
  instance.should_not be_nil
  save_object(name, instance)
end
