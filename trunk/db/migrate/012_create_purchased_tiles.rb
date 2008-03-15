class CreatePurchasedTiles < ActiveRecord::Migration
  def self.up
    create_table :purchased_tiles do |t|
      t.column :seat_id, :integer
      t.column :tile_id, :integer
    end
  end

  def self.down
    drop_table :purchased_tiles
  end
end
