require 'rails_helper'

RSpec.describe "Log in" do
  let!(:user) { create(:user, email: 'eli@example.com', password: 'password') }

  it 'signs in the user' do
    get '/users/sign_in'

    expect(response.body).to include("Sign in")

    post '/users/sign_in', params: { user: { email: 'eli@example.com', password: 'password' }}
    expect(response).to redirect_to(root_path)
    follow_redirect!

    expect(response.code).to eq("200")
  end
end

