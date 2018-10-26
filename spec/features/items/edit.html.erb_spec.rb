require 'rails_helper'

RSpec.describe "items/edit", type: :view do
  before(:each) do
    @item = assign(:item, Item.create!(
      :user => nil,
      :name => "MyString",
      :description => "MyString",
      :price => 1.5,
      :inventory => 1,
      :active => false
    ))
  end

  it "renders the edit item form" do
    render

    assert_select "form[action=?][method=?]", item_path(@item), "post" do

      assert_select "input[name=?]", "item[user_id]"

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[description]"

      assert_select "input[name=?]", "item[price]"

      assert_select "input[name=?]", "item[inventory]"

      assert_select "input[name=?]", "item[active]"
    end
  end
end
