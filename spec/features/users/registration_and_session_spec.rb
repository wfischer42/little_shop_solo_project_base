require 'rails_helper'

describe 'Registration and Session Management' do 
  describe 'Registration' do
    it 'anonymous visitor registers properly' do
      email = 'fred@gmail.com'
      visit register_path
  
      expect(current_path).to eq(register_path)
      fill_in :user_email, with: email
      fill_in :user_password, with: 'test1234'
      fill_in :user_name, with: 'Name'
      fill_in :user_address, with: 'Address'
      fill_in :user_city, with: 'City'
      fill_in :user_state, with: 'State'
      fill_in :user_zip, with: 'Zip'

      click_button 'Create User'
  
      expect(page).to have_content(email)
    end

    it 'anonymous visitor fails registration because it was blank' do
      visit new_user_path
      click_button 'Create User'
      expect(current_path).to eq(users_path)
      expect(page).to have_button("Create User")
    end

    it 'anonymous visitor fails registration because user existed' do
      email = 'fred@gmail.com'
      create(:user, email: email)
      visit new_user_path
      fill_in :user_email, with: email
      fill_in :user_password, with: '9876test'
      fill_in :user_name, with: 'Name'
      fill_in :user_address, with: 'Address'
      fill_in :user_city, with: 'City'
      fill_in :user_state, with: 'State'
      fill_in :user_zip, with: 'Zip'

      click_button 'Create User'
      expect(current_path).to eq(users_path)
      expect(page).to have_button("Create User")
    end
  end

  describe 'Login workflow' do
    before(:each) do
      @email = 'drpepper@gmail.com'
      @password = 'awesomesoda'
      @user = create(:user, email: @email, password: @password)
    end
    it 'should succeed if credentials are correct' do
      visit root_path
      click_link 'Log in'

      fill_in :email, with: @email
      fill_in :password, with: @password
      click_button 'Log in'
      expect(current_path).to eq(profile_path)
      expect(page).to have_content(@email)
    end

    it 'should fail if credentials are incorrect' do
      visit root_path
      click_link 'Log in'

      fill_in :email, with: @username
      fill_in :password, with: 'bad password'
      click_button 'Log in'
      expect(current_path).to eq(login_path)
      expect(page).to have_button("Log in")
      expect(page).to_not have_content(@email)
    end

    it 'should fail if credentials are empty' do
      visit login_path
      click_button 'Log in'
      expect(current_path).to eq(login_path)
      expect(page).to have_button("Log in")
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
      fill_in :email, with: @email
      fill_in :password, with: @password
      click_button 'Log in'
      expect(current_path).to eq(profile_path)

      click_link 'Log out'
      expect(current_path).to eq(root_path)
      expect(page).to_not have_content("Log out")
      expect(page).to have_content("Log in")
    end
  end
end