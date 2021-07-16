source 'https://rubygems.org'
ruby '3.0.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Default
gem 'rails', '6.1.4'
gem 'webpacker'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'pry'

# Added
gem 'uppy-s3_multipart'
gem 'streamio-ffmpeg'
gem 'font-awesome-rails'
gem 'kaminari'
gem 'aws-sdk-s3', '~> 1'
gem 'aws-sdk-elastictranscoder'
gem 'aws-sdk-cloudfront'
gem 'sucker_punch'
gem 'devise'
gem 'sidekiq'
gem 'omniauth-facebook'
gem 'cloudinary'
gem 'braintree'
gem 'paypal-sdk-rest'
gem 'sendgrid-ruby'
gem 'rack-cors'
gem 'bootsnap'
gem 'omdbapi'
gem 'themoviedb'
gem 'ffprober'
gem 'jwt'
gem 'tzinfo-data'
gem 'honeybadger'

group :development, :test do
  gem 'byebug'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'letter_opener'
end


