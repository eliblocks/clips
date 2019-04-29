class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def mux
    unless params["type"] == "video.asset.ready"
      puts "Wrong webhook type!"
      head :ok
    end
    playback_id = params["data"]["playback_ids"][0]["id"]
    video = Video.find_by(mux_playback_id: playback_id)
    if video.duration
      puts "Already processed video #{video.id}"
      head :ok
    end
    video.duration = params["data"]["tracks"].find { |track| track["type"] == "video" }["duration"]
    video.image = Cloudinary::Uploader.upload(video.mux_thumbnail_url, options = {}).public_id
    video.save!
    head :ok
  end
end
