class CreateReserveBoardTiles < ActiveRecord::Migration
  def self.up
    create_table :reserve_board_tiles do |t|
      t.column :seat_id, :integer
      t.column :tile_id, :integer
    end
  end

  def self.down
    drop_table :reserve_board_tiles
  end
end
