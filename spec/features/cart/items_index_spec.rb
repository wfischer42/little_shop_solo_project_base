require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Items Index' do
  context 'as a user' do
    before(:each) do
      @merchant = create(:merchant)
      @active_item = create(:item)
      @inactive_item = create(:inactive_item)
      create(:inventory_item, merchant: @merchant, item: @active_item)
      create(:inventory_item, item: @active_item)
      create(:inventory_item, item: @active_item)
      create(:inventory_item, merchant: @merchant, item: @inactive_item)
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end
    describe 'visiting /items' do
      it 'should show all active items' do
        visit items_path

        expect(page).to_not have_content(@inactive_item.name)

        within "#item-#{@active_item.id}" do
          expect(page).to have_content(@active_item.name)
          expect(page.find("#item-image-#{@active_item.id}")['src']).to have_content "https://picsum.photos/200/300?image=1"
          # TODO: Update to show price range after other stuff is fixed

          expect(page).to have_content("Sold by #{@active_item.inventory_items.count} merchants")
          expect(page).to have_content("Price range: #{number_to_currency(@active_item.min_price)} - #{number_to_currency(@active_item.max_price)}")


          click_link @active_item.name
        end
        expect(current_path).to eq(item_path(@active_item))

        visit items_path

        within "#item-#{@active_item.id}" do
          find(:xpath, "//a/img[@alt='image for #{@active_item.name}']/..").click
        end
        expect(current_path).to eq(item_path(@active_item))
      end
    end
    describe 'visiting /items/:id' do
      it 'should show all item information' do
        visit item_path(@active_item)

        expect(page).to have_content(@active_item.name)
        expect(page.find("#item-image-#{@active_item.id}")['src']).to have_content "https://picsum.photos/200/300?image=1"
        expect(page).to have_content("Base Price: #{number_to_currency(@active_item.price)}")

        # expect(page).to have_button("Add to Cart")
      end
      describe 'add item to cart' do
        # Should have multiple "add to cart"
        it 'should show all item content plus a button to add to cart' do
          visit item_path(@active_item)
          @active_item.inventory_items[0]
          expect(page).to have_content("Cart: 0")
          within("#inventory-item-#{@active_item.inventory_items[0].id}") do
            click_button("Add to Cart")
          end
          expect(page).to have_content("Cart: 1")
          expect(page).to have_content("Added another #{@active_item.name} to your cart")
          within("#inventory-item-#{@active_item.inventory_items[1].id}") do
            click_button("Add to Cart")
          end
          expect(page).to have_content("Cart: 2")
        end
      end
    end
    describe 'visiting /cart' do
      it 'should show all item content for what is in my cart' do
        FactoryBot.reload
        inv_item_1, inv_item_2 = create_list(:inventory_item, 2, merchant: @merchant)

        visit item_path(inv_item_1.item)
        within("#inventory-item-#{inv_item_1.id}") do
          click_button("Add to Cart")
        end
        visit item_path(inv_item_2.item)
        within("#inventory-item-#{inv_item_2.id}") do
          click_button("Add to Cart")
          click_button("Add to Cart")
        end

        visit carts_path
        within "#inventory-item-#{inv_item_1.id}" do
          expect(page).to have_content("Merchant: #{inv_item_1.merchant.name}")
          expect(page).to have_content(inv_item_1.item.name)
          # code smell, had to hard-code an ID in the image filename for factorybot sequence
          expect(page.find("#item-image-#{inv_item_1.item_id}")['src']).to have_content "https://picsum.photos/200/300?image=1"
          expect(page).to have_content("Price: #{number_to_currency(inv_item_1.unit_price)}")
          expect(page).to have_content("Quantity: 1")
          expect(page).to have_content("Subtotal: $#{inv_item_1.unit_price}")
        end
        within "#inventory-item-#{inv_item_2.id}" do
          expect(page).to have_content("Price: #{number_to_currency(inv_item_2.unit_price)}")
          expect(page).to have_content("Quantity: 2")
          expect(page).to have_content("Subtotal: $#{2 * inv_item_2.unit_price}")
        end
        expect(page).to have_content("Grand Total: $12.25")
        click_button "Check out"
      end
      it 'should allow me to empty my cart' do
        FactoryBot.reload
        inv_item_1, inv_item_2 = create_list(:inventory_item, 2, merchant: @merchant)

        visit item_path(inv_item_1.item)
        click_button("Add to Cart")
        click_button("Add to Cart")
        visit item_path(inv_item_2.item)
        click_button("Add to Cart")
        click_button("Add to Cart")

        visit carts_path
        expect(page).to have_content("Cart: 4")
        click_button "Empty Cart"
        expect(page).to have_content("Cart: 0")
      end
      it 'should block me from adding more items than a merchant has quantity' do
        FactoryBot.reload
        inv_item_1 = create(:inventory_item, merchant: @merchant)
        visit item_path(inv_item_1.item)
        click_button("Add to Cart")
        visit carts_path
        inv_item_1.inventory.times do |num|
          click_button("Add 1")
        end
        expect(page).to have_content("Cannot add another #{inv_item_1.item.name} to your cart, merchant doesn't have enough inventory")
      end
      it 'should allow me to change item quantities in my cart' do
        FactoryBot.reload
        inv_item_1, inv_item_2 = create_list(:inventory_item, 2, merchant: @merchant)

        visit item_path(inv_item_1.item)
        click_button("Add to Cart")
        expect(page).to have_content("Cart: 1")

        visit carts_path
        expect(page).to have_content("Grand Total: $3.05")
        within "#inventory-item-#{inv_item_1.id}" do
          expect(page).to have_content("Quantity: 1")
          click_button "Add 1"
        end

        expect(page).to have_content("Added another #{inv_item_1.item.name} to your cart")
        expect(page).to have_content("Cart: 2")
        visit carts_path
        within "#inventory-item-#{inv_item_1.id}" do
          expect(page).to have_content("Quantity: 2")
        end
        expect(page).to have_content("Grand Total: $6.10")
        within "#inventory-item-#{inv_item_1.id}" do
          click_button "Remove 1"
        end
        expect(page).to have_content("Removed #{inv_item_1.item.name} from your cart")

        expect(page).to have_content("Grand Total: $3.05")
        within "#inventory-item-#{inv_item_1.id}" do
          expect(page).to have_content("Quantity: 1")
          click_button "Remove All"
        end

        expect(page).to have_content("Removed entire quantity of #{inv_item_1.item.name} from your cart")
        expect(page).to have_content("Cart: 0")
        expect(page).to have_content("Grand Total: $0.00")
      end
    end
  end
  context 'as a visitor' do
    it 'should tell me to login/register if I am a visitor' do
      @merchant = create(:merchant)
      FactoryBot.reload
      inv_item_1, inv_item_2 = create_list(:inventory_item, 2, merchant: @merchant)

      visit item_path(inv_item_1.item)
      click_button("Add to Cart")
      visit carts_path
      within('#must-log-in') do
        expect(page).to have_content("You must register or log in to complete your purchase")
        expect(page).to have_link("register")
        expect(page).to have_link("log in")
      end
    end
  end
end
