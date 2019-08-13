desc "Reset user minute balances"
task reset_balances: [:environment] do
  User.includes(:plays, :charges).find_each do |user|
    puts "#{user.full_name} old balance: #{user.balance}"
    user.update(balance: user.calculated_balance)
    puts "#{user.full_name} new balance: #{user.balance}"
  end
end
