require 'rails_helper'

RSpec.describe "Merchant Items" do
  include ActionView::Helpers::NumberHelper
  context 'as a merchant' do
    before(:each) do
      @merchant = create(:merchant)
    end
    describe 'when I visit /dashboard' do
      it 'should show me a link to see my items for sale' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_path
        click_link 'My Items for Sale'

        expect(current_path).to eq(dashboard_inventory_items_path)
      end
    end

    describe 'when I visit my items page' do
      it 'should show all information about my items' do
        item_1, item_2 = create_list(:inventory_item, 2, merchant: @merchant)
        item_3 = create(:inventory_item, active: false, merchant: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_inventory_items_path
        within "#item-#{item_1.item_id}" do
          expect(page).to have_content("ID: #{item_1.item_id}")
          expect(page).to have_content(item_1.item.name)
          expect(page.find("#item-image-#{item_1.item_id}")['src']).to have_content(item_1.item.image)
          expect(page).to have_content("Markup: #{number_to_currency(item_1.markup)}")
          expect(page).to have_content("My Price: #{number_to_currency(item_1.item.price + item_1.markup)}")
          expect(page).to have_content("Inventory: #{item_1.inventory}")
          expect(page).to have_link("Edit Item")
          expect(page).to have_button("Disable Item")
        end
        within "#item-#{item_3.item_id}" do
          expect(page).to have_button("Enable Item")
        end
      end

      it 'should allow me to disable active items' do
        inv_item_1 = create(:inventory_item, merchant: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_inventory_items_path

        within "#item-#{inv_item_1.item_id}" do
          click_button "Disable Item"
        end
        expect(page).to have_content("Item #{inv_item_1.item_id} is now disabled in your store.")

        within "#item-#{inv_item_1.item_id}" do
          expect(page).to_not have_button("Disable Item")
          expect(page).to have_button("Enable Item")
        end
      end
      it 'should allow me to enable inactive items' do
        inv_item_1 = create(:inventory_item, active: false, merchant: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_inventory_items_path

        within "#item-#{inv_item_1.item_id}" do
          click_button "Enable Item"
        end
        expect(page).to have_content("Item #{inv_item_1.item_id} is now enabled in your store.")

        within "#item-#{inv_item_1.item_id}" do
          expect(page).to have_button("Disable Item")
          expect(page).to_not have_button("Enable Item")
        end
      end
      xit 'should allow me to add a new item' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit dashboard_inventory_items_path
        click_link "Add New Item"

        fill_in :item_name, with: 'New Item Name'
        fill_in :item_description, with: 'hottest item of 2018'
        fill_in :item_image, with: 'new-image.jpg'
        fill_in :item_price, with: 5
        fill_in :item_inventory, with: 100
        click_button 'Create Item'

        expect(current_path).to eq dashboard_inventory_items_path
        item = Item.last
        within "#item-#{item.id}" do
          expect(page).to have_content("ID: #{item.id}")
          expect(page).to have_content(item.name)
          expect(page.find("#item-image-#{item.id}")['src']).to have_content(item.image)
          expect(page).to have_content("Price: #{number_to_currency(item.price)}")
          expect(page).to have_content("Inventory: #{item.inventory}")
          expect(page).to have_link("Edit Item")
          # disabled by default
          expect(page).to have_button("Disable Item")
        end
      end
      xit 'should allow me to add a new item with a placeholder image' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit dashboard_inventory_items_path
        click_link "Add New Item"

        fill_in :item_name, with: 'New Item Name'
        fill_in :item_description, with: 'hottest item of 2018'
        fill_in :item_price, with: 5
        fill_in :item_inventory, with: 100
        click_button 'Create Item'

        expect(current_path).to eq dashboard_inventory_items_path
        item = Item.last
        within "#item-#{item.id}" do
          expect(page.find("#item-image-#{item.id}")['src']).to have_content('https://picsum.photos/200/300/?image=0&blur=true')
        end
      end
      xit 'should block me from adding a new item if form is blank' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit dashboard_inventory_items_path
        click_link "Add New Item"
        click_button 'Create Item' # no data submitted
        expect(current_path).to eq(merchant_items_path(@merchant))
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Description can't be blank")
        expect(page).to have_content("Price can't be blank")
        expect(page).to have_content("Price is not a number")
        expect(page).to have_content("Inventory can't be blank")
        expect(page).to have_content("Inventory is not a number")
      end
      it 'should allow me to edit an existing item' do
        inv_item = create(:inventory_item, merchant: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit dashboard_inventory_items_path
        within "#item-#{inv_item.item_id}" do
          click_link "Edit Item"
        end

        fill_in :item_name, with: 'New Item Name'
        fill_in :item_description, with: 'hottest item of 2018'
        fill_in :item_image, with: 'new-image.jpg'
        fill_in :item_price, with: 5
        click_button 'Update Item'

        expect(current_path).to eq dashboard_inventory_items_path
        item = Item.find(inv_item.item_id)
        within "#item-#{item.id}" do
          expect(page).to have_content('New Item Name')
          expect(page.find("#item-image-#{item.id}")['src']).to have_content('new-image.jpg')
          expect(page).to have_content("Price: #{number_to_currency(5)}")
        end
      end
      it 'should block me from editing a new item if require fields are blank' do
        inv_item = create(:inventory_item, merchant: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit dashboard_inventory_items_path
        within "#item-#{inv_item.item.id}" do
          click_link "Edit Item"
        end
        fill_in :item_name, with: ''
        fill_in :item_description, with: ''
        fill_in :item_price, with: ''
        click_button 'Update Item'

        expect(current_path).to eq(item_path(inv_item.item))
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Description can't be blank")
        expect(page).to have_content("Price can't be blank")
        expect(page).to have_content("Price is not a number")
      end
    end
  end
end
