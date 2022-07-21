source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "jsonapi.rb"
gem "jwt"
gem "lograge"
gem "paper_trail"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "ransack" # search functionality
gem "solargraph"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]


# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"
# gem "jbuilder"

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'capybara'
  gem 'database_cleaner'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fasterer'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'overcommit'
  gem 'rubocop'
  gem 'rubocop-config-prettier'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :test do
  gem 'simplecov', require: false
end