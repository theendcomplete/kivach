module IqsmsHelper
  module_function

  SEND_URL = 'https://api.iqsms.ru/messages/v2/send/'.freeze

  def send(phone, message, sender)
    params = {
      login: Rails.application.secrets.iqsms_login,
      password: Rails.application.secrets.iqsms_passwd,
      phone: "+#{phone.gsub(/[^0-9]+/, '')}",
      text: CGI.escape(message),
      sender: sender,
      statusQueueName: sender
    }.to_a.map { |t| t.join '=' }.join'&'
    # url = URI.parse "#{SEND_URL}?#{params}"
    # response = Net::HTTP.get_response uri
    connection = Faraday.new do |i|
      i.request  :url_encoded
      i.response :logger
      i.adapter  Faraday.default_adapter
    end
    response = connection.get "#{SEND_URL}?#{params}"
    body = JSON.parse(response.body)
    return body['messages'][0]['status'] if body.present? && body['messages'].present? && body['messages'][0]['status'] != 'accepted'
  end
end
