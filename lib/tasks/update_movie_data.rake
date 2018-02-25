desc "refresh movie data"
task update_movie_data: [:environment] do
  Video.movies.each do |video|
    video.update_from_omdb
  end
end




