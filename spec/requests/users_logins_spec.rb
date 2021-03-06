require 'rails_helper'

RSpec.describe "UsersLogins", type: :request do
  include SessionsHelper
  
  let(:user){create(:user)}
  
  def post_valid_information(remember_me = 0)
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
        remember_me: remember_me
      }
    }
  end
  
  it "does not log out twice" do
    get login_path
    post_valid_information(0)
    expect(is_logged_in?).to be_truthy
    follow_redirect!
    expect(request.fullpath).to eq '/users/1'
    delete logout_path
    expect(is_logged_in?).to be_falsey
    follow_redirect!
    expect(request.fullpath).to eq '/'
    delete logout_path
    follow_redirect!
    expect(request.fullpath).to eq '/'
  end

  it "succeeds remember_token because of check remember_me" do
    get login_path
    post_valid_information(1)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).not_to be_nil
  end

  it "has no remember_token because of check remember_me" do
    get login_path
    post_valid_information(0)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).to be_nil
  end

  it "has no remember_token when users logged out and logged in" do
    get login_path
    post_valid_information(1)
    expect(is_logged_in?).to be_truthy
    expect(cookies[:remember_token]).not_to be_empty
    delete logout_path
    expect(is_logged_in?).to be_falsey
    expect(cookies[:remember_token]).to be_empty
  end
    
  
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
