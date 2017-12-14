class User < ApplicationRecord

  after_create :create_account

  #other modules: :lockable, :timeoutable
  has_many :videos, dependent: :destroy
  has_one :account, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  devise :omniauthable, :omniauth_providers => [:facebook] #todo: remove?

  def create_account
    account = Account.new(user_id: id, image: Rails.configuration.default_profile_image)
    if account.save
      print "Account created!!"
    else
      print account.errors.full_messages
    end
  end

  def uploader?
    videos.any?
  end

  def viewer?
    !uploader?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      #user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
