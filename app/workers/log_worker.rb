class LogWorker
  include Sidekiq::Worker
  sidekiq_options queue: :logs, retry: 5, dead: false

  def perform(title, text = '')
    SlackHelper.info(title, text)
  end
end
