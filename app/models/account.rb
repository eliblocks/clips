class Account < ApplicationRecord
  belongs_to :user
  has_many :plays, dependent: :destroy
  has_many :charges
  has_many :payments


  def subtract_balance(play)
    new_balance = balance - play.duration
    update(balance: new_balance)
  end

  def image_id
    image.split('/')[1]
  end

  def image_version
    image.split('/')[0]
  end

  def self.cl_base_url
    "https://res.cloudinary.com/eli/image/upload"
  end

  def image_url
    "#{Video.cl_base_url}/#{image_id}"
  end

  def add_balance(seconds)
    new_balance = balance + seconds
    update(balance: new_balance)
  end

  def receivable
    #stub value
    if balance > 1000
      balance - 1000
    else
      0
    end
  end

  def watch_video(video, count)
    count.times {
      play = Play.create!(video_id: video.id, account_id: id, duration: 10)
      video.update_views(play)
      subtract_balance(play)
    }
  end

  #copied from videos project

  def uploader?
    user.videos.any?
  end

  def last_purchase_date
    if charges.any?
      charges.order(created_at: :desc).first.created_at
    else
      created_at
    end
  end

  def minutes_used_last_30
    plays.where('created_at > ?', 30.days.ago).sum(:duration) / 60
  end

  def minutes_purchased_last_30
    charges.where('created_at > ?', 30.days.ago).sum(:seconds) / 60
  end

  def plays_earned_last(n)
    Play.where('created_at > ?', n.days.ago)
      .where(video_id: user.videos.ids)
  end

  def minutes_earned_last(n)
    plays_earned_last(n).sum(:duration) / 60
  end

  def seconds_purchased
    charges.sum(:seconds) || 0
  end

  def seconds_played
    plays.sum(:duration) || 0
  end

  def seconds_paid
    payments.sum(:seconds) || 0
  end

  def video_earnings_last(n)
    Play.select(:video_id, :duration)
      .where('created_at > ?', n.days.ago)
      .where(video_id: user.videos.ids)
      .group(:video_id)
      .sum(:duration)
  end

  def uploader_plays_last(n)
    plays.joins(:video)
      .where('plays.created_at > ?', n.days.ago)
      .group('videos.user_id')
      .sum(:duration)
  end

  def video_plays_last(n)
    plays.where('created_at > ?', n.days.ago)
      .group(:video_id)
      .sum(:duration)
  end


  def most_earned_videos(num_videos, num_days)
    top_videos = video_earnings_last(num_days).sort_by { |k,v| v}.reverse!.first(num_videos).to_h
    top_videos.transform_keys { |k| Video.find(k) }
  end

  def most_watched_uploaders(num_uploaders, num_days)
    top_uploaders = uploader_plays_last(num_days).sort_by { |k, v| v }.reverse!.first(num_uploaders).to_h
    top_uploaders.transform_keys { |k| User.find(k) }
  end

  def most_watched_videos(num_videos, num_days)
    top_watches = video_plays_last(num_days).sort_by { |k,v| v }.reverse!.first(num_videos).to_h
    top_watches.transform_keys { |k| Video.find(k) }
  end


  def total_minutes_earned
    seconds_earned = user.videos.pluck(:views).reduce(:+)
    if seconds_earned
      return seconds_earned/60
    else
      return 0
    end
  end

end
