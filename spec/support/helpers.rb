module Helpers
  def sign_in(user)
    post '/users/sign_in', params: {
      user: { email: user.email, password: 'password' }
    }
  end
end
