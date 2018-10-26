class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :items, through: :order_items

  validates_presence_of :status

  def total 
    oi = order_items.pluck("sum(quantity*price)")
    oi.sum
  end
end
