class RemoveUserIdFromVideos < ActiveRecord::Migration[6.0]
  def change
    remove_reference :videos, :user, index: true
    add_reference :videos, :account, index: true
  end
end
