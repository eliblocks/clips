class SendWelcomeEmailJob < ApplicationJob
  def perform(creator)
    return if creator.videos.exists?

    ApplicationMailer.creator_welcome_email(creator).deliver_now
  end
end