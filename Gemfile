source 'https://rubygems.org'

gem 'activeadmin', '~> 2.7'
gem 'activeadmin_addons', '~> 1.7.1'
gem 'active_skin', github: 'SoftwareBrothers/active_skin'
gem 'bootsnap', require: false
gem 'daemons', '~> 1.3.1'
gem 'data_migrate'
gem 'delayed_job_active_record', '~> 4.1.4'
gem 'devise'
gem 'devise-encryptable'
gem 'devise-i18n'
gem 'enumerize'
gem 'exponent-server-sdk'
gem 'firebase', '~> 0.2.8'
gem 'has_secure_token'
gem 'httparty', '~> 0.18.0'
gem 'jbuilder', '~> 2.7'
gem 'ledgerizer', github: 'platanus/ledgerizer', ref: 'master'
gem 'oauth-plugin' # splitwise api requirements
gem 'pg'
gem 'power_api'
gem 'power-types'
gem 'puma', '~> 3.12'
gem 'rack-cors', '~> 1.1'
gem 'rails', '~> 6.0.0'
gem 'rails-i18n'
gem 'sass-rails', '~> 5'
gem 'send_grid_mailer'
gem 'strong_migrations'
gem 'tiddle'
gem 'turbolinks', '~> 5'
gem 'warden'
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
  gem 'rails_db', '2.3.1'
  gem 'rspec-nc', require: false
  gem 'rspec-rails'
  gem 'rswag-specs'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :production, :development, :test do
  gem 'tzinfo-data'
end
