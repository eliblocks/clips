class PlaysController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @play = Play.new(play_params)
    @play.price = @play.video.price
    @play.account_id = current_account.id

    if @play.save
      @play.update_balances
      @play.update_views
    else
      puts @play.errors.full_messages
    end
    head :ok
  end

  private

  def play_params
    params.require(:play).permit(:video_id, :duration)
  end
end
