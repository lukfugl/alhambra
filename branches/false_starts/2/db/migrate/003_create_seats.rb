class CreateSeats < ActiveRecord::Migration
  def self.up
    create_table :seats do |t|
      t.belongs_to :table, :null => false
      t.belongs_to :player
      t.column :slot, :integer
      t.column :color, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :seats
  end
end
