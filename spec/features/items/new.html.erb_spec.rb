require 'rails_helper'

RSpec.describe "items/new", type: :view do
  before(:each) do
    assign(:item, Item.new(
      :user => nil,
      :name => "MyString",
      :description => "MyString",
      :price => 1.5,
      :inventory => 1,
      :active => false
    ))
  end

  it "renders new item form" do
    render

    assert_select "form[action=?][method=?]", items_path, "post" do

      assert_select "input[name=?]", "item[user_id]"

      assert_select "input[name=?]", "item[name]"

      assert_select "input[name=?]", "item[description]"

      assert_select "input[name=?]", "item[price]"

      assert_select "input[name=?]", "item[inventory]"

      assert_select "input[name=?]", "item[active]"
    end
  end
end
