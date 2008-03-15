class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.column :name, :string
      t.timestamps
    end
    add_column :seats, :player_id, :integer
  end

  def self.down
    remove_column :seats, :player_id
    drop_table :players
  end
end
