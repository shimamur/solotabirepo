require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  
  let(:user){create(:user)}
  
  describe "GET /login" do
    context "invalid information" do
      it "has a danger flash message because of invalid login information"  do
        get login_path
        post login_path, params: {
          session: {
            email: "",
            password: ""
          }
        }
        expect(flash[:danger]).to be_trurhy
        expect(is_logged_in?).to be_falsey
      end
    end
    
    context "valid information" do
      it "success having no danger flash message" do
        get login_path
        post login_path, params: {
          session: {
            email: user.email,
            password: user.password
          }
        }
        expect(flash[:danger]).to be_falsey
        expect(is_logged_in?).to be_trurhy
      end
      
      it "success login and logout" do
        get login_path
        post login_path, params: {
          session: {
            email: user.email,
            password: user.password
          }
        }
        expect(is_logged_in?).to be_trurhy
        delete logout_path
        expect(is_logged_in?).to be_falsey
      end
      
    
    end
end
