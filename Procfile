web: bundle exec puma -C ./config/puma.rb
release: bin/release

log: tail -f log/development.log
worker: bundle exec rake jobs:work