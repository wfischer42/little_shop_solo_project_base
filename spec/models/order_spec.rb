require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'Relationships' do
    it { should belong_to(:user) }
    it { should have_many(:order_items) }
    it { should have_many(:items).through(:order_items) }
  end

  describe 'Validations' do 
    it { should validate_presence_of(:status) }
  end

  describe 'Class Methods' do 
  end

  describe 'Instance Methods' do
    it '.total' do
      @user = create(:user)
      @merchant = create(:merchant)
      @item_1, @item_2, @item_3 = create_list(:item, 3, user: @merchant)
      
      @order_1 = create(:order, user: @user)
      oi_1 = create(:order_item, order: @order_1, item: @item_1)
      oi_2 = create(:order_item, order: @order_1, item: @item_2)
      oi_3 = create(:order_item, order: @order_1, item: @item_3)
  
      expect(@order_1.total).to eq(oi_1.subtotal + oi_2.subtotal + oi_3.subtotal)
    end
  end
end
