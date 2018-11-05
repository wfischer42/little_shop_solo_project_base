require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'Relationships' do
    it { should belong_to(:order) }
    it { should belong_to(:inventory_item)}
  end

  describe 'Validations' do
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price)
           .is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of(:quantity)
           .is_greater_than_or_equal_to(0) }
  end

  describe 'Class Methods' do
  end

  describe 'Instance Methods' do
    it '.subtotal' do
      @user = create(:user)
      @merchant = create(:merchant)
      @inv_item_1 = create(:inventory_item, merchant: @merchant)

      @order_4 = create(:order, user: @user)
      order_item = create(:order_item, order: @order_4, inventory_item: @inv_item_1)

      expect(order_item.subtotal).to eq(12.0)
    end
  end
end
