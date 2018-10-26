require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      :email => "MyString",
      :password_digest => "MyString",
      :name => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString",
      :role => 1,
      :active => false
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input[name=?]", "user[email]"

      assert_select "input[name=?]", "user[password_digest]"

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
