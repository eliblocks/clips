source 'https://rubygems.org'
ruby '2.7.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Default
gem 'rails', '6.0.3.2'
gem 'webpacker'
gem 'pg'
gem 'puma'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'jquery-ui-rails'
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
gem 'jquery-fileupload-rails'
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
gem 'honeybadger', '~> 4.0'

group :development, :test do
  gem 'byebug'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'spring-commands-rspec'
  gem 'rspec-rails'
  gem 'letter_opener'
end


