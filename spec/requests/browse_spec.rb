require 'rails_helper'

RSpec.describe "browse" do
  context 'when logged in' do
    let(:user) { create(:user) }
    before { sign_in(user) }

    it 'does not redirect user' do
      get '/videos'

      expect(response.status).to eq(200)
    end
  end

  context 'when not logged in' do
    it 'redirects to sign up path' do
      get ('/videos')

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
