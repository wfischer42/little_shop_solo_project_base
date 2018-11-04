class RemoveItemFromOrderItems < ActiveRecord::Migration[5.1]
  def change
    remove_reference :order_items, :item, foreign_key: true
  end
end
