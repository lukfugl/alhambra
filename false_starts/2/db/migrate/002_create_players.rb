class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.column :username, :string
      t.column :name, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
