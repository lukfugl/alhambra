class CreateBuildingSupplyTiles < ActiveRecord::Migration
  def self.up
    create_table :building_supply_tiles do |t|
      t.column :game_id, :integer
      t.column :rank, :integer
      t.column :tile_id, :integer
    end
  end

  def self.down
    drop_table :building_supply_tiles
  end
end
