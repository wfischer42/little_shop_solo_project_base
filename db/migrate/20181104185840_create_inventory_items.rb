class CreateInventoryItems < ActiveRecord::Migration[5.1]
  def change
    create_table :inventory_items do |t|
      t.references :user, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :inventory, default: 0
      t.decimal :markup, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
