class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :plays, dependent: :destroy
  has_many :charges
  has_many :payments
  has_many :videos

  before_create :set_username

  def first_name
    full_name.split(" ")&.first
  end

  def to_param
    username
  end

  def set_username
    self.username ||= SecureRandom.alphanumeric(8)
  end

  def uploader?
    videos.any?
  end

  def viewer?
    !uploader?
  end

  def self.from_omniauth(auth, origin)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.full_name = auth.info.name
      user.link = auth.extra.raw_info.link
      user.referrer = origin
      user.skip_confirmation!
    end
  end

  has_many_attached :clips

  def image_id
    image.split('/')[1]
  end

  def self.cl_base_url
    "https://res.cloudinary.com/eli/image/upload"
  end

  def image_url
    "#{Video.cl_base_url}/#{image_id}"
  end

  def receivable
    #stub value
    if balance > 1000
      balance - 1000
    else
      0
    end
  end

  def uploader?
    videos.any?
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
      .where(video_id: videos.ids)
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

  def seconds_earned
    views = videos.pluck(:views).reduce(:+) || 0
    views * (1 - Rails.configuration.commission)
  end

  def calculated_balance
    seconds_purchased - seconds_played - seconds_paid + 6000 + seconds_earned
  end

  def video_earnings_last(n)
    Play.select(:video_id, :duration)
      .where('created_at > ?', n.days.ago)
      .where(video_id: videos.ids)
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
    if seconds_earned
      return seconds_earned/60
    else
      return 0
    end
  end
end
