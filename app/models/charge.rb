class Charge < ApplicationRecord
  belongs_to :account

  def create_from_transaction(transaction)
    self.seconds = Rails.configuration.rate * transaction.amount.to_i
    self.gateway_charge_id = transaction.id
    self.amount = transaction.amount.to_i
    save!
    account.update_balance(self.seconds)
  end
end
