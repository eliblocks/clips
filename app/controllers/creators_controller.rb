class CreatorsController < ApplicationController
  def new
    @user = User.new
    @minimum_password_length = 6
  end

  def create
    @user = User.new(user_params)
    @user.category = "uploader"
    @user.save

    if @user.persisted?
      flash[:success] = "Welcome to Browzable!"
      sign_in(@user)
      redirect_to "/library"
      ApplicationMailer.new_creator_signup_email(current_user).deliver_later
      SendWelcomeEmailJob.set(wait: 1.hour).perform_later(@user)
    else
      @user.password = nil
      @minimum_password_length = 6
      render action: "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :username, :email, :password)
  end
end