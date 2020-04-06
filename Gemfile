source 'https://rubygems.org'

gem 'bootsnap', require: false
gem 'data_migrate'
gem 'devise'
gem 'devise-i18n'
gem 'enumerize'
gem 'jbuilder', '~> 2.7'
gem 'pg'
gem 'power-types'
gem 'puma', '~> 3.11'
gem 'rack-cors', '~> 1.1'
gem 'rails', '~> 6.0.0'
gem 'rails-i18n'
gem 'sass-rails', '~> 5'
gem 'strong_migrations'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

group :development do
  gem 'annotate', '~> 3.0'
  gem 'listen'
  gem 'spring'
end

group :production do
  gem 'heroku-stage'
  gem 'rack-timeout'
  gem 'rails_stdout_logging'
end

group :test do
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'shoulda-matchers', require: false
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec', require: false
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-nc', require: false
  gem 'rspec-rails'
end

group :production, :development, :test do
  gem 'tzinfo-data'
end
