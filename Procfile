web: bundle exec puma -C ./config/puma.rb
release: bin/release

log: tail -f log/development.log
RAILS_ENV=production script/delayed_job start

