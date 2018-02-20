require 'httparty'

desc "refresh movie data"
task update_movie_data: [:environment] do
  Video.movies.each do |video|
    response = HTTParty.get("http://www.omdbapi.com/?i=tt#{video.imdb_id}&apikey=#{ENV['OMDB_KEY']}")
    parsed_response = response.parsed_response
    attrs = {
      title: parsed_response['Title'],
      published_at: parsed_response['Released'],
      rating: parsed_response['Rated'],
      runtime: parsed_response['Runtime'],
      description: parsed_response['Plot'],
      language:  parsed_response['Language']
    }

    genres = parsed_response['Genre']

    puts "updating #{video.title}"

    video.tag_list = genres if genres

    if video.update(attrs)
      puts "updated #{video.title}"
    else
      puts "#{video.title} failed to update"
    end

  end
end




