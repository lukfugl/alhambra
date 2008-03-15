ActiveRecord::Schema.define do
  create_table "tiles", :force => true do |t|
    t.column :building_type, :string
    t.column :walls, :string
    t.column :cost, :integer
  end

  create_table "cards", :force => true do |t|
    t.column :currency, :string
    t.column :value, :integer
  end

  create_table "players", :force => true do |t|
    t.column :name, :string
  end

  create_table "games", :force => true do |t|
    t.column :active_seat_id, :integer
    t.column :name, :string
    t.column :state, :string
  end

  create_table "building_supply_tiles", :force => true do |t|
    t.column :game_id, :integer
    t.column :rank, :integer
    t.column :tile_id, :integer
  end

  create_table "currency_supply_cards", :force => true do |t|
    t.column :game_id, :integer
    t.column :rank, :integer
    t.column :card_id, :integer
  end

  create_table "building_market_tiles", :force => true do |t|
    t.column :game_id, :integer
    t.column :currency, :string
    t.column :tile_id, :integer
  end

  create_table "currency_market_cards", :force => true do |t|
    t.column :game_id, :integer
    t.column :card_id, :integer
  end

  create_table "seats", :force => true do |t|
    t.column :game_id, :integer
    t.column :player_id, :string
    t.column :color, :string
  end

  create_table "hand_cards", :force => true do |t|
    t.column :seat_id, :integer
    t.column :card_id, :integer
  end

  create_table "alhambra_tiles", :force => true do |t|
    t.column :seat_id, :integer
    t.column :x, :integer
    t.column :y, :integer
    t.column :tile_id, :integer
  end

  create_table "reserve_board_tiles", :force => true do |t|
    t.column :seat_id, :integer
    t.column :tile_id, :integer
  end

  create_table "purchased_tiles", :force => true do |t|
    t.column :seat_id, :integer
    t.column :tile_id, :integer
  end
end
