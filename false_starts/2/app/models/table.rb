class Table < ActiveRecord::Base
  has_many :seats, :dependent => :destroy
  has_many :players, :through => :seats
end
