require 'rails_helper'


RSpec.describe 'Merchant Orders' do 
  before(:each) do
    @user = create(:user)
    @merchant = create(:merchant)
    @item_1, @item_2, @item_3, @item_4, @item_5 = create_list(:item, 5, user: @merchant)
    
    @order_1 = create(:order, user: @user)
    create(:order_item, order: @order_1, item: @item_1)
    create(:order_item, order: @order_1, item: @item_2)

    @order_2 = create(:fulfilled_order, user: @user)
    create(:order_item, order: @order_2, item: @item_2)
    create(:order_item, order: @order_2, item: @item_3)

    @admin = create(:admin)
  end

  context 'merchant user' do 
    it 'sees a link to view dashboard orders if there are any orders' do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_path 
 
      click_link("Merchant Orders")
      
      expect(current_path).to eq(dashboard_orders_path)
    end
    it 'sees a link to view dashboard orders if there are any orders' do 
      merchant_2 = create(:merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_2)

      visit dashboard_path 
      
      expect(page).to_not have_link("Merchant Orders")
    end
    it 'can display orders containing items sold by that merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_orders_path

      expect(page).to have_content(@user.email)
      expect(page).to have_content("Order ##{@order_1.id}")
      expect(page).to_not have_content("Order ##{@order_2.id}")
    end
  end

  context 'admin user' do
    it 'sees a link to edit merchant profile data' do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit merchant_path(@merchant) 
 
      click_link "Edit Profile Data"
      expect(current_path).to eq(edit_user_path(@merchant))
    end
    it 'sees a link to view dashboard orders if there are any orders' do 
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit merchant_path(@merchant) 

      click_link("Merchant Orders")

      expect(current_path).to eq(merchant_orders_path(@merchant))
      expect(page).to have_content(@user.email)
      expect(page).to have_content("Order ##{@order_1.id}")
      expect(page).to have_content("Order ##{@order_2.id}")
    end
  end
end