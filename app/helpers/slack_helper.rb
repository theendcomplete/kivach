module SlackHelper
  def self.send(text, attachments)
    webhook_url = Rails.configuration.app['slack_webhook_url']
    return if webhook_url.blank?

    text = Slack::Notifier::Util::Escape.html text
    notifier = Slack::Notifier.new webhook_url, http_options: { open_timeout: 5 }
    notifier.post text: text, attachments: attachments
  end

  def self.error(err)
    title = nil
    title_short = ''
    if err.request_method.present?
      title = "#{err.request_method} #{err.request_original_url}"[0..255]
      title_short = "@ #{err.request_original_url[%r{/\/([^\/]+)\//}, 1]}"
    end
    text = err.message[0, 200] if err.message.is_a?(String)
    footer = "#{Rails.env} | #{Rails.name} #{Rails.version}"
    timestamp = err.created_at.to_i
    send(
      "Internal server error ##{error.id}#{title_short}",
      [
        {
          title: title,
          text: text,
          footer: footer,
          ts: timestamp
        }
      ]
    )
  end

  def self.info(title, message = '')
    footer = "#{Rails.env} | #{Rails.name} #{Rails.version}"
    timestamp = Time.current.to_i
    send(
      title,
      [
        {
          text: message,
          footer: footer,
          ts: timestamp
        }
      ]
    )
  end
end
