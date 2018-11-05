class RemoveInventoryFromItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :inventory, :integer
  end
end
