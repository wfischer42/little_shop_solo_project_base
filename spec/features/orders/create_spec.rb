require 'rails_helper'

RSpec.describe 'Create Order' do 
  context 'as a registered user' do
    before(:each) do 
      @merchant = create(:merchant)
      @active_item = create(:item, user: @merchant)
      @inactive_item = create(:inactive_item, name: 'inactive item 1')
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    it 'allows me to check out and create an order' do 
      item_1, item_2 = create_list(:item, 2, user: @merchant)
      visit item_path(item_1)
      click_button("Add to Cart")
      visit item_path(item_2)
      click_button("Add to Cart")

      visit carts_path
      click_button "Check out"
      expect(current_path).to eq(profile_orders_path)
      order = Order.last

      within("#order-#{order.id}") do
        order.order_items.each do |o_item|
          within("#order-details-#{order.id}") do
            expect(page).to have_content(o_item.item.name)
          end
        end
      end
    end
  end
end