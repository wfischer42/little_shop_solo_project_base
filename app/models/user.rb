class User < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :inventory_items
  has_many :items, through: :inventory_items
  has_many :order_items, through: :inventory_items
  has_many :merchant_orders, -> { distinct },
           through: :order_items,
           class_name: :Order,
           foreign_key: "order_id"

  has_many :customers, -> { distinct },
           through: :merchant_orders,
           class_name: :User,
           foreign_key: "user_id"

  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, presence: true, uniqueness: true

  enum role: %w(user merchant admin)

  def merchant_orders(status=nil)
    return super() if status.nil?
    return super().where(status: status) if status
  end

  def merchant_for_order?(order)
    order.in?(merchant_orders)
  end

  def total_items_sold
    items
      .joins(:orders)
      .where("orders.status != ?", :cancelled)
      .where("order_items.fulfilled=?", true)
      .sum("order_items.quantity")
  end

  def total_inventory
    items.sum(:inventory)
  end

  def top_shipping(metric, quantity)
    items
      .joins(:orders)
      .joins('join users on orders.user_id=users.id')
      .where("orders.status != ?", :cancelled)
      .where("order_items.fulfilled=?", true)
      .order("count(users.#{metric}) desc")
      .group("users.#{metric}")
      .limit(quantity)
      .pluck("users.#{metric}")
  end

  def top_3_shipping_states
    top_shipping(:state, 3)
  end

  def top_3_shipping_cities
    top_shipping(:city, 3)
  end

  def top_active_user
    User
      .select('users.*, count(orders.id) as order_count')
      .joins(:orders)
      .joins('join order_items on orders.id=order_items.order_id')
      .joins('join inventory_items on order_items.inventory_item_id=inventory_items.id')
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .where('inventory_items.user_id = ? AND users.active=?', id, true)
      .group(:id)
      .order('order_count desc')
      .limit(1)
      .first
  end

  def biggest_order
    Order
      .select('orders.*, sum(order_items.quantity) as item_count')
      .joins(:items)
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .where('inventory_items.user_id=?', id)
      .order('order_items.quantity desc')
      .group('inventory_items.user_id, orders.id, order_items.id')
      .limit(1)
      .first
  end

  def top_buyers(quantity=3)
    User
      .select('users.*, sum(order_items.quantity*order_items.price) as total_spent')
      .joins(:orders)
      .joins('join order_items on orders.id=order_items.order_id')
      .joins('join inventory_items on order_items.inventory_item_id=inventory_items.id')
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .where('inventory_items.user_id = ? AND users.active=?', id, true)
      .group(:id)
      .order('total_spent desc')
      .limit(quantity)
  end

  def self.top_merchants(quantity)
    select('distinct users.*, sum(order_items.quantity*order_items.price) as total_earned')
      .joins(:inventory_items)
      .joins('join order_items on inventory_items.id=order_items.inventory_item_id')
      .joins('join orders on orders.id=order_items.order_id')
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .group('orders.id, users.id, order_items.id')
      .order('total_earned desc, users.name')
      .limit(quantity)
  end

  def self.popular_merchants(quantity)
    select('users.*, coalesce(count(order_items.id),0) as total_orders')
      .joins('join inventory_items on inventory_items.user_id=users.id')
      .joins('join order_items on order_items.inventory_item_id=inventory_items.id')
      .joins('join orders on orders.id=order_items.order_id')
      .where('orders.status != ?', :cancelled)
      .where('order_items.fulfilled = ?', true)
      .group(:id)
      .order('total_orders desc, users.name asc')
      .limit(quantity)
  end

  def self.merchant_by_speed(quantity, order)
    select("distinct users.*,
      CASE
        WHEN order_items.updated_at > order_items.created_at THEN coalesce(EXTRACT(EPOCH FROM order_items.updated_at) - EXTRACT(EPOCH FROM order_items.created_at),0)
        ELSE 1000000000 END as time_diff")
      .joins(:inventory_items)
      .joins('join order_items on inventory_items.id=order_items.inventory_item_id')
      .joins('join orders on orders.id=order_items.order_id')
      .where('orders.status != ?', :cancelled)
      .group('orders.id, users.id, order_items.updated_at, order_items.created_at')
      .order("time_diff #{order}")
      .limit(quantity)
  end

  def self.fastest_merchants(quantity)
    merchant_by_speed(quantity, :asc)
  end

  def self.slowest_merchants(quantity)
    merchant_by_speed(quantity, :desc)
  end
end
