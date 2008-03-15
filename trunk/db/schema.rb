# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 13) do

  create_table "alhambra_tiles", :force => true do |t|
    t.integer "seat_id"
    t.integer "x"
    t.integer "y"
    t.integer "tile_id"
  end

  create_table "building_market_tiles", :force => true do |t|
    t.integer "game_id"
    t.string  "currency"
    t.integer "tile_id"
  end

  create_table "building_supply_tiles", :force => true do |t|
    t.integer "game_id"
    t.integer "rank"
    t.integer "tile_id"
  end

  create_table "cards", :force => true do |t|
    t.string  "currency"
    t.integer "value"
  end

  create_table "currency_market_cards", :force => true do |t|
    t.integer "game_id"
    t.integer "card_id"
  end

  create_table "currency_supply_cards", :force => true do |t|
    t.integer "game_id"
    t.integer "rank"
    t.integer "card_id"
  end

  create_table "games", :force => true do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_seat_id"
  end

  create_table "hand_cards", :force => true do |t|
    t.integer "seat_id"
    t.integer "card_id"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchased_tiles", :force => true do |t|
    t.integer "seat_id"
    t.integer "tile_id"
  end

  create_table "reserve_board_tiles", :force => true do |t|
    t.integer "seat_id"
    t.integer "tile_id"
  end

  create_table "seats", :force => true do |t|
    t.integer  "game_id"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_id"
  end

  create_table "tiles", :force => true do |t|
    t.string  "building_type"
    t.string  "walls"
    t.integer "cost"
  end

end
