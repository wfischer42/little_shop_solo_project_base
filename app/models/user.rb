class User < ApplicationRecord
  has_secure_password

  has_many :orders
  has_many :items

  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, presence: true, uniqueness: true

  enum role: %w(user merchant admin)

  def merchant_orders(status=nil)
    if status.nil?
      Order.distinct.joins(:items).where('items.user_id=?', self.id)
    else
      Order.distinct.joins(:items).where('items.user_id=? AND orders.status=?', self.id, status)
    end
  end

  def merchant_for_order(order)
    !Order.distinct.joins(:items).where('items.user_id=? and orders.id=?', self.id, order.id).empty?
  end
end
