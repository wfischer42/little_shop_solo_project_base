require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Relationships' do
    it { should have_many(:inventory_items) }
    it { should have_many(:order_items).through(:inventory_items) }
    it { should have_many(:orders).through(:order_items) }
    it { should have_many(:customers).through(:orders) }
    it { should have_many(:merchants).through(:inventory_items) }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price)
           .is_greater_than_or_equal_to(0) }
  end

  describe 'Class Methods' do
    it '.popular_items(quantity)' do
      user = create(:user)
      merchants = create_list(:merchant, 2)
      inv_item_1 = create(:inventory_item, merchant: merchants[0])
      inv_item_2 = create(:inventory_item, merchant: merchants[0])
      inv_item_3 = create(:inventory_item, merchant: merchants[1])
      inv_item_4 = create(:inventory_item, merchant: merchants[1])
      orders = create_list(:completed_order, 2, user: user)
      create(:fulfilled_order_item, quantity: 10, inventory_item: inv_item_1, order: orders[0])
      create(:fulfilled_order_item, quantity: 20, inventory_item: inv_item_2, order: orders[0])
      create(:fulfilled_order_item, quantity: 40, inventory_item: inv_item_3, order: orders[1])
      create(:fulfilled_order_item, quantity: 30, inventory_item: inv_item_4, order: orders[1])

      expect(Item.popular_items(3)).to eq([inv_item_3.item, inv_item_4.item, inv_item_2.item])
    end
  end
end
