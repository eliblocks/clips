require 'rails_helper'

RSpec.describe "Sign up" do
  it 'registers the user' do
    get '/users/sign_up'

    expect(response.body).to include("Sign up")

    post '/users', params: { user: { email: 'eli@example.com', password: 'password' }}

    user = User.last
    expect(response).to redirect_to(user_path(user))

    expect(User.count).to eq(1)
    expect(user.email).to eq("eli@example.com")
    expect(user.valid_password?("password")).to eq(true)
  end
end
