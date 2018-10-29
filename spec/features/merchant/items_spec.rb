require 'rails_helper'

RSpec.describe 'Merchant Items' do 
=begin
  As a merchant
  When I visit my dashboard page ("/dashboard")
  I see a link to view my own items
  When I click that link
  My URI route should be "/dashboard/items"
=end
  context 'as a merchant' do
    before(:each) do 
      @merchant = create(:merchant)
    end
    describe 'when I visit /dashboard' do 
      it 'should show me a link to see my items for sale' do
        # item_1, item_2 = create_list(:item, user: @merchant)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

        visit dashboard_path

        click_link 'My Items for Sale'
        
        expect(current_path).to eq(dashboard_items_path)
      end
    end
  end



end