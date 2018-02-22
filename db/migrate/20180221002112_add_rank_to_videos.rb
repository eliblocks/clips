class AddRankToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :rank, :integer
  end
end
