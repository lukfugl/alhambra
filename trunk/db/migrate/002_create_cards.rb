class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.column :currency, :string
      t.column :value, :integer
    end

    cards = YAML::load(File.read(File.join(RAILS_ROOT + '/db/cards.yml')))
    cards.each{ |card| Card.create(card) }
  end

  def self.down
    drop_table :cards
  end
end
