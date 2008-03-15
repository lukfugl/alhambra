require 'yaml'

class CreateTiles < ActiveRecord::Migration
  def self.up
    create_table "tiles" do |t|
      t.column :building_type, :string
      t.column :walls, :string
      t.column :cost, :integer
    end

    tiles = YAML::load(File.read(File.join(RAILS_ROOT + '/db/tiles.yml')))
    tiles.each{ |tile| Tile.create(tile) }
  end

  def self.down
    drop_table :tiles
  end
end
