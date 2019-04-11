class DropVisits < ActiveRecord::Migration[6.0]
  def change
    drop_table :visits
  end
end
