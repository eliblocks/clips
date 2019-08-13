class ChargesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    if current_user.balance < 10
      flash.now[:notice] = "You're out of minutes! Buy more to keep watching"
    end
    @charge = Charge.new
    @client_token = Braintree::ClientToken.generate
    result = attempt_sale(@amount, params[:nonce])
  end

  def create
    @amount = "5.00"
    result = attempt_sale(@amount, params[:nonce])
    if result.success?
      puts "success!: #{result.transaction.id}"
      @charge = current_user.charges.new
      @charge.create_from_transaction(result.transaction)
      flash[:success] = "Payment successful!"
      redirect_after_payment
    elsif result.transaction
      flash[:danger] = "Error Processing Transaction"
      puts "Error processing transaction:"
      puts "  code: #{result.transaction.processor_response_code}"
      puts "  text: #{result.transaction.processor_response_text}"
      redirect_to new_charge_path
    else
      flash[:danger] = "Error Processing Transaction"
      p result.errors
      redirect_to new_charge_path
    end
  end

  def attempt_sale(amount, nonce)
    Braintree::Transaction.sale(
      :amount => amount,
      :payment_method_nonce => nonce,
      :options => {
        :submit_for_settlement => true
      }
    )
  end

  def redirect_after_payment
    video_id = session[:video_id]
    ref = session[:ref]
    puts "video_id:  #{video_id}"
    puts "ref: #{ref}"
    session.delete(:video_id)
    session.delete(:ref)

    if video_id
      video = Video.find(video_id)
      if ref == 'site'
        redirect_to video_path(video)
      elsif ref == 'embed'
        redirect_to thank_you_path
      end
    else
      redirect_to root_path
    end
  end

end
