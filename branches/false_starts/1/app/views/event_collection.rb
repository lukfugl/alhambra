def body
  return events.map{ |event| Resources::Event.new(event).url }.to_yaml
end
