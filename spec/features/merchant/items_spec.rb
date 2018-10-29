require 'rails_helper'

RSpec.describe 'Merchant Items' do 
  context 'as a merchant' do
    before(:each) do 
      @merchant = create(:merchant)
    end
    describe 'when I visit /dashboard' do 
      it 'should show me a link to see my items for sale' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_path

        click_link 'My Items for Sale'
        
        expect(current_path).to eq(dashboard_items_path)
      end
    end
    describe 'when I visit my items page' do
      it 'should show all information about my items' do
        item_1, item_2 = create_list(:item, 2, user: @merchant)
        item_3 = create(:inactive_item, user: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_items_path

        within "#item-#{item_1.id}" do 
          expect(page).to have_content("ID: #{item_1.id}")
          expect(page).to have_content(item_1.name)
          # code smell, had to hard-code an ID in the image filename for factorybot sequence
          expect(page.find("#item-image-#{item_1.id}")['src']).to have_content "image-1.jpg"
          expect(page).to have_content("Price: #{item_1.price}")
          expect(page).to have_content("Inventory: #{item_1.inventory}")
          expect(page).to have_link("Edit Item")
          expect(page).to have_button("Disable Item")
        end
        within "#item-#{item_3.id}" do 
          expect(page).to have_button("Enable Item")
        end
      end
      it 'should allow me to disable active items' do
        item_1 = create(:item, user: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_items_path

        within "#item-#{item_1.id}" do 
          click_button "Disable Item"
        end
        expect(page).to have_content("Item #{item_1.id} is now disabled")

        within "#item-#{item_1.id}" do 
          expect(page).to_not have_button("Disable Item")
          expect(page).to have_button("Enable Item")
        end
      end
      it 'should allow me to enable inactive items' do
        item_1 = create(:inactive_item, user: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_items_path

        within "#item-#{item_1.id}" do 
          click_button "Enable Item"
        end
        expect(page).to have_content("Item #{item_1.id} is now enabled")

        within "#item-#{item_1.id}" do 
          expect(page).to have_button("Disable Item")
          expect(page).to_not have_button("Enable Item")
        end
      end
    end
  end
end