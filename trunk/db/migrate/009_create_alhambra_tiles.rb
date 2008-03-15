class CreateAlhambraTiles < ActiveRecord::Migration
  def self.up
    create_table :alhambra_tiles do |t|
      t.column :seat_id, :integer
      t.column :x, :integer
      t.column :y, :integer
      t.column :tile_id, :integer
    end
  end

  def self.down
    drop_table :alhambra_tiles
  end
end
