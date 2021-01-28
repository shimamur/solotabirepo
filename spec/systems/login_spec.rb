require 'rails_helper'

RSpec.describe "Logins", type: :system do
  
  let(:user) { create(:user)}
  
  context "login with invalid information" do
    it "is invalid because it has no information" do
      visit login_path
      expect(page).to have_selector '.login-container'
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      find(".form-submit").click
      expect(current_path).to eq login_path
      expect(page).to have_selector '.login-container'
      expect(page).to have_selector '.alert-danger'
    end
    
    it "delete flash messages when users input invalid information then other links" do
      visit login_path
      expect(page).to have_selector '.login-container'
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      find(".form-submit").click
      expect(current_path).to eq login_path
      expect(page).to have_selector '.login-container'
      expect(page).to have_selector '.alert-danger'
      vist root_path
      expect(page).not_to have_selector '.alert-danger'
    end
  end
  
  context "login with valid information" do
    it "is valid becaus it has valid information" do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      faind(".form-submit").click
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.show-container'
    end
  end
  
      
end