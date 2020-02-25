require 'faraday'
require 'json'
require 'erb'

class SmsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :sms, retry: 3, dead: false

  def perform(template = 'default', params = {})
    process template, params
  end

  private

  def process(template, params)
    message = ViewHelper.render_view('workers/sms/' + template, params['view'])

    sender = params['sender']
    recipients = params['recipients']

    log_title = 'SMS Message'
    log_message = "From: #{sender}\nTo: #{recipients.map { |v| Utils.mask_phone v }.join(', ')}\n\n#{message}"

    adapters = params['adapter'] || Rails.configuration.app['email_adapter']
    (adapters.is_a?(Array) ? adapters : [adapters]).each do |adapter|
      case adapter.to_sym
      when :console
        puts log_title
        puts log_message
      when :slack
        SlackHelper.info(log_title, log_message)
      when :smsc
        SmscHelper.send(recipients, message, sender: sender, mail: false)
      end
    rescue StandardError => e
      LogHelper.error e
      throw e
    end
  end
end
