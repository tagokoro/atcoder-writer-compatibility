require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/crontab.log"

every 1.day, at: '6:00 am' do
  rake "scrape_task:latest"
end