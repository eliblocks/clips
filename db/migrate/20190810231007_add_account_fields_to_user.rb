class AddAccountFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :image, :string
    add_column :users, :balance, :integer, default: 6000
  end
end
