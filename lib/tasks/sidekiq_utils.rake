namespace :sidekiq_utils do
  desc 'Clear queues'
  task clear: :environment do
    require 'sidekiq/api'
    Sidekiq::ScheduledSet.new.clear
    Sidekiq::RetrySet.new.clear
  end
end
