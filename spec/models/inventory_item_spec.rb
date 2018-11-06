require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  describe 'Relationships' do
    it { should belong_to(:merchant) }
    it { should belong_to(:item) }
    it { should have_many(:order_items) }
  end

  describe 'Validations' do
    it { should validate_numericality_of(:markup)
           .is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:inventory)
           .is_greater_than_or_equal_to(0) }
  end
  describe 'Instance Methods' do
    describe '.unit_price' do
      subject { create(:inventory_item).unit_price }
      let(:inv_item) { InventoryItem.last }
      it { is_expected.to eq( inv_item.markup + inv_item.item.price) }
    end
  end
end
