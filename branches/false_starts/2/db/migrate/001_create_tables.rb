class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :tables do |t|
      t.column :name, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :tables
  end
end
