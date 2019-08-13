class ProfileController < ApplicationController

  def update
    current_user.update(profile_params)
    respond_to do |format|
      format.js { head :ok }
    end
  end

  def profile_params
    params.require(:user).permit(:image, :paypal_email)
  end
end
