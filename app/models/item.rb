class Item < ApplicationRecord
  has_many :inventory_items
  has_many :order_items, through: :inventory_items
  has_many :orders, through: :order_items
  has_many :customers,
           through: :orders,
           class_name: :User,
           foreign_key: "user_id"

  has_many :merchants,
           through: :inventory_items,
           class_name: :User,
           foreign_key: "user_id"

  validates_presence_of :name, :description
  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than_or_equal_to: 0
  }

  def min_price
    return price unless inventory_items.any?
    price + inventory_items.minimum(:markup)
  end

  def max_price
    return price unless inventory_items.any?
    inventory_items.maximum(:markup) + price
  end

  def self.not_stocked_by(merchant)
    Item.where('items.id NOT IN (?)', merchant.item_ids)
  end

  def self.popular_items(quantity)
    select('items.*, sum(order_items.quantity) as total_ordered')
      .joins(:orders)
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .group('items.id, order_items.id')
      .order('total_ordered desc')
      .limit(quantity)
  end
end
