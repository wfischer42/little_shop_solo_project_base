class InventoryItem < ApplicationRecord
  belongs_to :merchant,
               class_name: :User,
               foreign_key: "user_id"
  belongs_to :item
  has_many :order_items

  validates :inventory, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :markup, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }

  def unit_price
    markup + item.price
  end
end
