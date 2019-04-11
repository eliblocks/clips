class ProbeVideoJob < ApplicationJob
  def perform(video, signed_url)
    metadata = S3VideoAnalyzer.new(signed_url).metadata
    video.duration = metadata[:duration]
    video.save!
  end
end