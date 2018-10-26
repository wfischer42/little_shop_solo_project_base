require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :email => "MyString",
      :passowrd_digest => "MyString",
      :name => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString",
      :role => 1,
      :active => false
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input[name=?]", "user[email]"

      assert_select "input[name=?]", "user[passowrd_digest]"

      assert_select "input[name=?]", "user[name]"

      assert_select "input[name=?]", "user[address]"

      assert_select "input[name=?]", "user[city]"

      assert_select "input[name=?]", "user[state]"

      assert_select "input[name=?]", "user[zip]"

      assert_select "input[name=?]", "user[role]"

      assert_select "input[name=?]", "user[active]"
    end
  end
end
