class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def new_creator_signup_email(creator)
    @creator = creator
    mail(to: "eliyahu.block@gmail.com", subject: "New browzable creator")
  end
end
