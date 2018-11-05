class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :merchant_order, class_name: :Order, foreign_key: 'order_id'
  belongs_to :inventory_item

  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }
  validates :quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def subtotal
    quantity * price
  end
end
