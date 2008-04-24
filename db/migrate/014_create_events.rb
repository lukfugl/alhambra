class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :type, :string
      t.column :game_id, :integer
      t.column :event_data, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
