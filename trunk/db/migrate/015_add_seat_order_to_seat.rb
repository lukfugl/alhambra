class AddSeatOrderToSeat < ActiveRecord::Migration
  def self.up
    add_column :seats, :seat_order, :integer
  end

  def self.down
    remove_column :seats, :seat_order
  end
end
