require 'rails_helper'

describe 'Admin-only user management' do 
  before(:each) do
    @admin = create(:admin)
    @active_user = create(:user)
    @inactive_user = create(:inactive_user)
  end
  it 'allows admin to disable an enabled user account' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'
  
    visit users_path

    within "#user-#{@active_user.id}" do
      click_button "Disable"
    end
    expect(current_path).to eq(users_path)
    within "#user-#{@active_user.id}" do
      expect(page).to_not have_button("Disable")
      expect(page).to have_button("Enable")
    end

    visit logout_path
    visit login_path
    fill_in :email, with: @active_user.email
    fill_in :password, with: @active_user.password
    click_button 'Log in'
    expect(current_path).to eq(login_path)
    expect(page).to have_content('Your account is disabled')
  end

  it 'allows admin to enable a disabled user account' do
    visit login_path
    fill_in :email, with: @admin.email
    fill_in :password, with: @admin.password
    click_button 'Log in'

    visit users_path
    within "#user-#{@inactive_user.id}" do
      click_button "Enable"
    end
    expect(current_path).to eq(users_path)
    within "#user-#{@inactive_user.id}" do
      expect(page).to have_button("Disable")
      expect(page).to_not have_button("Enable")
    end

    visit logout_path
    visit login_path
    fill_in :email, with: @inactive_user.email
    fill_in :password, with: @inactive_user.password
    click_button 'Log in'
    
    expect(current_path).to eq(profile_path)
  end

  xit 'allows admin to upgrade a user to a merchant' do

  end

  xit 'allows admin to downgrade a merchant to a user' do

  end
end