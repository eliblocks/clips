class AddS3IdToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :s3_id, :string
  end
end
