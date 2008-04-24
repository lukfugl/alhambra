class CreateCurrencySupplyCards < ActiveRecord::Migration
  def self.up
    create_table :currency_supply_cards do |t|
      t.column :game_id, :integer
      t.column :rank, :integer
      t.column :card_id, :integer
    end
  end

  def self.down
    drop_table :currency_supply_cards
  end
end
