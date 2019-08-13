class ChangeChargesAccountIdToUserId < ActiveRecord::Migration[6.0]
  def change
    rename_column :charges, :account_id, :user_id
    rename_column :videos, :account_id, :user_id
    rename_column :payments, :account_id, :user_id
    rename_column :plays, :account_id, :user_id

    remove_foreign_key :charges, :accounts
    remove_foreign_key :payments, :accounts
    remove_foreign_key :plays, :accounts

    add_foreign_key :charges, :users
    add_foreign_key :videos, :users
    add_foreign_key :payments, :users
    add_foreign_key :plays, :users
  end
end
