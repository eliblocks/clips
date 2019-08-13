require 'paypal-sdk-rest'

class Payer
  def initialize(user)
    @user = user
    @amount = @user.receivable
    @payout = build_payout
    @paypal_batch_id = SecureRandom.hex(8)
    @paypal_payment_id = SecureRandom.hex(12)
  end

  def build_payout
    PayPal::SDK::REST::DataTypes::Payout.new(
      {
        :sender_batch_header => {
          :sender_batch_id => @paypal_batch_id,
          :email_subject => 'You have a Payout!',
        },
        :items => [
          {
            :recipient_type => 'EMAIL',
            :amount => {
              :value => @amount.to_s,
              :currency => 'USD'
            },
            :note => 'Thanks for your patronage!',
            :receiver => @user.email,
            :sender_item_id => @paypal_payment_id,
          }
        ]
      }
    )
  end

  def pay
    begin
      @payout_batch = @payout.create
      Rails.logger.info "Created Payout with [#{@payout_batch.batch_header.payout_batch_id}]"
    rescue PayPal::SDK::Core::Exceptions::ResourceNotFound => err
      Rails.logger.error payout.error.inspect
    end
    batch = Batch.create(paypal_id: @paypal_batch_id)
    payment = Payment.create(batch_id: batch.id, user_id: @user.id)
    new_balance = @user.balance - @amount
    @user.update(balance: new_balance)
  end
end
