class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.column :name, :string
      t.column :summary, :string
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table :games
  end
end
