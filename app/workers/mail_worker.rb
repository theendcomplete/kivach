require 'faraday'
require 'json'
require 'erb'

class MailWorker
  include Sidekiq::Worker
  sidekiq_options queue: :mails, retry: 3, dead: false

  def perform(template = 'default', params = {})
    process template, params
  end

  private

  def process(template, params)
    message = ViewHelper.render_view('workers/mails/' + template, params['view'])

    sender = params['sender']
    recipients = params['recipients']
    subject = params['subject']

    log_title = 'Mail message'
    log_message = "From: #{sender}\nTo: #{recipients.join(', ')}\nSubject: #{subject}\n\n#{message}"

    adapters = params['adapter'] || Rails.configuration.app['email_adapter']
    (adapters.is_a?(Array) ? adapters : [adapters]).each do |adapter|
      case adapter.to_sym
      when :console
        puts log_title
        puts log_message
      when :slack
        SlackHelper.info(log_title, log_message)
      when :smsc
        SmscHelper.send(recipients, message, subject: subject, sender: sender, mail: true)
      end
    end
  end
end
