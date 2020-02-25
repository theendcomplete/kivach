module SmscHelper
  SEND_URL = 'https://smsc.ru/sys/send.php'.freeze

  def self.send(recipients, message, mail: nil, subject: nil, sender: nil)
    request_params = {
      login: Rails.application.secrets.smsc_login,
      psw: Rails.application.secrets.smsc_password,
      phones: recipients.join(','),
      mes: message,
      charset: 'utf-8',
      fmt: 3
    }

    request_params[:subj] = subject if subject.present?
    request_params[:sender] = sender if sender.present?
    request_params[:mail] = 1 if mail.present?

    connection = Faraday.new do |i|
      i.request  :url_encoded
      i.response :logger
      i.adapter  Faraday.default_adapter
    end
    response = connection.post SEND_URL, request_params
    body = JSON.parse(response.body)
    raise body['error'] if body.present? && body['error_code'].present?
  end
end
