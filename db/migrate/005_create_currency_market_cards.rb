class CreateCurrencyMarketCards < ActiveRecord::Migration
  def self.up
    create_table :currency_market_cards do |t|
      t.column :game_id, :integer
      t.column :card_id, :integer
    end
  end

  def self.down
    drop_table :currency_market_cards
  end
end
