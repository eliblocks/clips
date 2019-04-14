class AddMuxPlaybackIdToVideos < ActiveRecord::Migration[6.0]
  def change
    rename_column :videos, :mux_id, :mux_asset_id
    add_column :videos, :mux_playback_id, :string
  end
end
