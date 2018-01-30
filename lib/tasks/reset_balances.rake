desc "Reset Account minute balances"
task reset_balances: [:environment] do
  Account.includes(:plays, :charges).find_each do |account|
    puts "user: #{account.user.full_name}"
    puts "old balance: #{account.balance}"
    new_balance = account.seconds_purchased - account.seconds_played - account.seconds_paid + 6000 + account.seconds_earned
    account.update(balance: new_balance)
    puts "new balance: #{account.balance}"
  end
end
