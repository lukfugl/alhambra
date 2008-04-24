class CreateSeats < ActiveRecord::Migration
  def self.up
    create_table :seats do |t|
      t.column :game_id, :integer
      t.column :color, :string
      t.timestamps
    end
    add_column :games, :active_seat_id, :integer
  end

  def self.down
    remove_column :games, :active_seat_id
    drop_table :seats
  end
end
