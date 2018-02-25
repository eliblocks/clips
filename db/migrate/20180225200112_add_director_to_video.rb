class AddDirectorToVideo < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :director, :string
  end
end
