class AddStorageUrlToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :storage_url, :string
  end
end
