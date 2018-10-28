require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Relationships' do
    it { should have_many(:orders) }
    it { should have_many(:items) }
  end

  describe 'Validations' do 
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe 'Class Methods' do 
  end

  describe 'Instance Methods' do 
    it '.merchant_items' do
      @user = create(:user)
      @merchant = create(:merchant)
      @item_1, @item_2, @item_3, @item_4, @item_5 = create_list(:item, 5, user: @merchant)
      
      @order_1 = create(:order, user: @user)
      create(:order_item, order: @order_1, item: @item_1)
      create(:order_item, order: @order_1, item: @item_2)
  
      @order_2 = create(:fulfilled_order, user: @user)
      create(:order_item, order: @order_2, item: @item_2)
      create(:order_item, order: @order_2, item: @item_3)

      expect(@merchant.merchant_orders).to eq([@order_1, @order_2])
    end
    it '.merchant_items(:pending)' do
      @user = create(:user)
      @merchant = create(:merchant)
      @item_1, @item_2, @item_3, @item_4, @item_5 = create_list(:item, 5, user: @merchant)
      
      @order_1 = create(:order, user: @user)
      create(:order_item, order: @order_1, item: @item_1)
      create(:order_item, order: @order_1, item: @item_2)
  
      @order_2 = create(:fulfilled_order, user: @user)
      create(:order_item, order: @order_2, item: @item_2)
      create(:order_item, order: @order_2, item: @item_3)

      expect(@merchant.merchant_orders(:pending)).to eq([@order_1])
    end
  end
end
