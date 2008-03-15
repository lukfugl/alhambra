def body
  return seats.map{ |seat| Resources::Seat.new(seat).url }.to_yaml
end
