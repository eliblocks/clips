class Play < ApplicationRecord
  belongs_to :user
  belongs_to :video

  def update_balances
    user.update(balance: user.balance - duration)
    video.user.update(balance: video.user.balance + creator_share)
  end

  def update_views
    video.update(views: video.views + duration)
  end

  def creator_share
    duration * (1 - Rails.configuration.commission)
  end
end
