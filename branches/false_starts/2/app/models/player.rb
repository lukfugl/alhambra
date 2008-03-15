class Player < ActiveRecord::Base
  has_many :seats
  has_many :tables, :through => :seats
end
