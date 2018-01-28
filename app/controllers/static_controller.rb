class StaticController < ApplicationController
  def about
  end

  def contact
  end

  def privacy
  end

  def terms
  end

  def stats
  end

  def welcome
    if user_signed_in?
      redirect_to root_path
    end
  end

  def upload
    version = params[:v]
    if version == '2'
      render 'static/upload2'
    elsif version == '3'
      render 'static/upload3'
    end
  end
end
