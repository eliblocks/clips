require 'httparty'

imdb_id = 3030354

response = HTTParty.get("http://www.omdbapi.com/?i=tt#{imdb_id}&apikey=#{ENV['OMDB_KEY']}")
parsed_response = response.parsed_response

attrs = {
  title: parsed_response['Title'],
  published_at: parsed_response['Released'],
  rating: parsed_response['Rated'],
  runtime: parsed_response['Runtime'],
  description: parsed_response['Plot'],
  language:  parsed_response['Language'],
  director: parsed_response['Director']
}

genres = parsed_response['Genre']

puts parsed_response




