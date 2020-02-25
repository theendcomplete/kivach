module LogHelper
  def self.info(text)
    LogWorker.perform_async(text)
  end

  def self.error(error)
    return puts(error.backtrace) if Rails.env.to_sym == :development

    SlackHelper.error error
  end
end
