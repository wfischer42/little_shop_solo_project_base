class OrderItem < ApplicationRecord
  belongs_to :order
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
    s = quantity * price
    s
  end
end
