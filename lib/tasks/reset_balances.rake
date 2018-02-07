desc "Reset Account minute balances"
task reset_balances: [:environment] do
  Account.includes(:plays, :charges).find_each do |account|
    puts "#{account.user.full_name} old balance: #{account.balance}"
    account.update(balance: account.calculated_balance)
    puts "#{account.user.full_name} new balance: #{account.balance}"
  end
end
