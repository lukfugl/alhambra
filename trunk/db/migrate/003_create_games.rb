class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.column :name, :string
      t.column :state, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
