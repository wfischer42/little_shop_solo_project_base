require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before(:each) do
    assign(:items, [
      Item.create!(
        :user => nil,
        :name => "Name",
        :description => "Description",
        :price => 2.5,
        :inventory => 3,
        :active => false
      ),
      Item.create!(
        :user => nil,
        :name => "Name",
        :description => "Description",
        :price => 2.5,
        :inventory => 3,
        :active => false
      )
    ])
  end

  it "renders a list of items" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
