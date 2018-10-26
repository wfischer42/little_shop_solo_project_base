require 'rails_helper'

describe 'Registration and Session Management' do 
  describe 'Registration' do 
    xit 'anonymous visitor fails registration because it was blank' do
      visit new_user_path
      click_on 'Create User'
      expect(current_path).to eq(users_path)
      expect(page).to have_button("Create User")
    end
  
    xit 'anonymous visitor fails registration because user existed' do
      email = 'fred@gmail.com'
      create(:user, email: email)
      visit new_user_path
      fill_in :user_email, with: email
      fill_in :user_password, with: '9876test'
  
      click_on 'Create User'
      expect(current_path).to eq(users_path)
      expect(page).to have_button("Create User")
    end
  
    xit 'anonymous visitor' do
      email = 'fred@gmail.com'
      username = 'fred'
      visit '/'
  
      click_on 'Register'
  
      expect(current_path).to eq(register_path)
      fill_in :user_email, with: email
      fill_in :user_password, with: 'test1234'
  
      click_on 'Create User'
  
      expect(page).to have_content("Welcome, #{username}")
    end
  end

  describe 'Login workflow' do
    before(:each) do
      @email = 'drpepper@gmail.com'
      @password = 'awesomesoda'
      @user = create(:user, email: @email)
    end
    it 'should succeed if credentials are correct' do
      visit root_path
      click_on 'Log in'

      fill_in :email, with: @email
      fill_in :password, with: @password
      click_on 'Log In'
      expect(current_path).to eq(profile_path)
      expect(page).to have_content(@email)
    end

    it 'should fail if credentials are incorrect' do
      visit root_path
      click_on 'Log in'

      fill_in :email, with: @username
      fill_in :password, with: 'bad password'
      click_on 'Log In'
      expect(current_path).to eq(login_path)
      expect(page).to have_button("Log In")
      expect(page).to_not have_content(@email)
    end

    it 'should fail if credentials are empty' do
      visit root_path
      click_on 'Register'
      # leave the form blank
      click_on 'Log In'
      expect(current_path).to eq(login_path)
      expect(page).to have_button("Log In")
      expect(page).to_not have_content(@email)
    end
  end

  describe 'Logout workflow' do
    before(:each) do
      @email = 'drpepper@gmail.com'
      @password = 'awesomesoda'
      @user = create(:user, email: @email, password: @password)
    end
    it 'should succeed if credentials are correct' do
      visit login_path
      fill_in :email, with: @username
      fill_in :password, with: @password
      click_on 'Log In'

      # already tested in nav, but let's make sure
      expect(page).to_not have_link(login_path)
      expect(page).to have_link(logout_path)
      
      click_link 'Log out'
      expect(current_path).to eq(root_path)
      expect(page).to_not have_content("Log out")
      expect(page).to have_content("Log in")
    end
  end
end