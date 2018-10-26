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
  end
end
