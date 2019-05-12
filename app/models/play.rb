class Play < ApplicationRecord
  belongs_to :account
  belongs_to :video

  def update_balances
    account.update(balance: account.balance - duration)
    video.account.update(balance: video.account.balance + creator_share)
  end

  def update_views
    video.update(views: video.views + duration)
  end

  def creator_share
    duration * (1 - Rails.configuration.commission)
  end
end
