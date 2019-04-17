class UpdateVideoJob < ApplicationJob
  def perform(video)
    14.times do
      sleep 2
      mux_asset = video.get_mux_asset
      
      mux_status = video.mux_status(mux_asset)
      puts "Transcoding status: #{mux_status}"
      if mux_status == "ready"
        video.image = Cloudinary::Uploader.upload(video.mux_thumbnail_url, options = {}).public_id
        video.duration = video.mux_duration(mux_asset)
        video.save!
        break
      end
    end
    puts "VideoUpdateJob failed" unless video.duration > 0
  end
end