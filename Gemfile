# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
gem 'active_model_serializers', '~> 0.10.0'
# CORS support
gem 'rack-cors', require: 'rack/cors'
gem 'dotenv-rails', '~> 2.2.0'
gem 'sorcery', '~> 0.10.3'
gem 'knock', '~> 2.1.1'
gem 'responders', '~> 2.3.0'
gem 'kaminari', '~> 1.0.1'
gem 'pg_search', '~> 2.0.1'
gem 'carrierwave', '~> 1.0.0'
gem 'newrelic_rpm', '~> 4.0.0.332'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'rubocop', '~> 0.47.1', require: false
  gem 'rubocop-rspec', '~> 1.13.0', require: false
  gem 'factory_girl_rails', '~> 4.8'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano3-puma'
end

group :test do
  gem 'database_cleaner', '~> 1.5.3'
  gem 'simplecov'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
