desc "Reset video minutes viewed"
task reset_views: [:environment] do
  Video.all.each do |video|
    puts "#{video.title} Old views: #{video.views}"
    video.update(views: video.seconds_played)
    puts "#{video.title} New views: #{video.views}"
  end
end
