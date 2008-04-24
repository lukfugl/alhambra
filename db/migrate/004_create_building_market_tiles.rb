class CreateBuildingMarketTiles < ActiveRecord::Migration
  def self.up
    create_table :building_market_tiles do |t|
      t.column :game_id, :integer
      t.column :currency, :string
      t.column :tile_id, :integer
    end
  end

  def self.down
    drop_table :building_market_tiles
  end
end
