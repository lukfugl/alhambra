class CreateHandCards < ActiveRecord::Migration
  def self.up
    create_table :hand_cards do |t|
      t.column :seat_id, :integer
      t.column :card_id, :integer
    end
  end

  def self.down
    drop_table :hand_cards
  end
end
