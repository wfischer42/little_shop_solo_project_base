require 'rails_helper'

RSpec.describe 'Item Stats' do
  context 'seeing stats when visiting /items' do
    before(:each) do
      @user = create(:user)
      @merchants = create_list(:merchant, 10)
      @inv_item_1 = create(:inventory_item, merchant: @merchants[0])
      @inv_item_2 = create(:inventory_item, merchant: @merchants[1])
      @inv_item_3 = create(:inventory_item, merchant: @merchants[2])
      @inv_item_4 = create(:inventory_item, merchant: @merchants[3])
      @inv_item_5 = create(:inventory_item, merchant: @merchants[4])
      @inv_item_6 = create(:inventory_item, merchant: @merchants[5])
      @inv_item_7 = create(:inventory_item, merchant: @merchants[6])
      @inv_item_8 = create(:inventory_item, merchant: @merchants[7])
      @inv_item_9 = create(:inventory_item, merchant: @merchants[8])
      @inv_item_A = create(:inventory_item, merchant: @merchants[9])
    end
    it 'shows 5 most popular items' do
      orders = create_list(:completed_order, 1, user: @user)
      create(:fulfilled_order_item, order: orders[0], inventory_item: @inv_item_9, quantity: 6)
      create(:fulfilled_order_item, order: orders[0], inventory_item: @inv_item_5, quantity: 10)
      create(:fulfilled_order_item, order: orders[0], inventory_item: @inv_item_2, quantity: 4)
      create(:fulfilled_order_item, order: orders[0], inventory_item: @inv_item_8, quantity: 7)
      create(:fulfilled_order_item, order: orders[0], inventory_item: @inv_item_3, quantity: 3)

      visit items_path
      within('#stats') do
        within('#popular-items') do
        popular = Item.popular_items(5)
          expect(page).to have_content("#{@inv_item_5.item.name}, ordered #{popular[0].total_ordered} times")
          expect(page).to have_content("#{@inv_item_8.item.name}, ordered #{popular[1].total_ordered} times")
          expect(page).to have_content("#{@inv_item_9.item.name}, ordered #{popular[2].total_ordered} times")
          expect(page).to have_content("#{@inv_item_2.item.name}, ordered #{popular[3].total_ordered} times")
          expect(page).to have_content("#{@inv_item_3.item.name}, ordered #{popular[4].total_ordered} times")
        end
      end
    end
    it 'shows 5 most popular merchants' do
      orders = create_list(:completed_order, 5, user: @user)
      create(:fulfilled_order_item, order: orders[0], inventory_item: @inv_item_9, quantity: 6)
      create(:fulfilled_order_item, order: orders[0], inventory_item: @inv_item_8, quantity: 6)
      create(:fulfilled_order_item, order: orders[1], inventory_item: @inv_item_5, quantity: 10)
      create(:fulfilled_order_item, order: orders[1], inventory_item: @inv_item_1, quantity: 10)
      create(:fulfilled_order_item, order: orders[2], inventory_item: @inv_item_2, quantity: 4)
      create(:fulfilled_order_item, order: orders[2], inventory_item: @inv_item_8, quantity: 4)
      create(:fulfilled_order_item, order: orders[3], inventory_item: @inv_item_8, quantity: 7)
      create(:fulfilled_order_item, order: orders[3], inventory_item: @inv_item_A, quantity: 7)
      create(:fulfilled_order_item, order: orders[4], inventory_item: @inv_item_3, quantity: 3)
      create(:fulfilled_order_item, order: orders[4], inventory_item: @inv_item_2, quantity: 3)
      create(:fulfilled_order_item, order: orders[4], inventory_item: @inv_item_8, quantity: 3)

      visit items_path
      within('#stats') do
        within('#popular-merchants') do
          popular = User.popular_merchants(5)
          expect(page).to have_content("#{@merchants[7].name}, ordered from #{popular[0].total_orders} times")
          expect(page).to have_content("#{@merchants[1].name}, ordered from #{popular[1].total_orders} times")
          expect(page).to have_content("#{@merchants[0].name}, ordered from #{popular[2].total_orders} times")
        end
      end
    end
    context 'merchants by speed' do
      before(:each) do
        orders = create_list(:order, 5, user: @user)
        create(:fulfilled_order_item, order: orders[0], inventory_item: @inv_item_1)
        create(:fulfilled_order_item, created_at: 3.seconds.ago, order: orders[0], inventory_item: @inv_item_3)
        create(:fulfilled_order_item, created_at: 3.minutes.ago, order: orders[0], inventory_item: @inv_item_5)
        create(:fulfilled_order_item, created_at: 3.hours.ago, order: orders[0], inventory_item: @inv_item_7)
        create(:fulfilled_order_item, created_at: 3.days.ago, order: orders[0], inventory_item: @inv_item_9)
        create(:order_item, order: orders[0], inventory_item: @inv_item_1)
      end
      it 'shows 3 merchants fastest at fulfilling orders' do
        visit items_path
        within('#stats') do
          within('#fastest-merchants') do
            expect(page).to have_content("#{@merchants[2].name} #{@merchants[4].name} #{@merchants[6].name}")
          end
        end
      end
      it 'shows 3 merchants slowest at fulfilling orders' do
        visit items_path
        within('#stats') do
          within('#slowest-merchants') do
            expect(page).to have_content("#{@merchants[0].name} #{@merchants[8].name} #{@merchants[6].name}")
          end
        end
      end
    end
  end
end
