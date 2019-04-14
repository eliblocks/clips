class AddMuxIdToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :mux_id, :string
  end
end
