class FcmWorker
  include Sidekiq::Worker
  sidekiq_options queue: :fcms, retry: 5, dead: false

  def perform(user_id, deeplink, notification, data = {})
    return if user_id.blank? || notification.blank?

    token = User.new(id: user_id).fcm_topic_name

    notification = {
      sound: 'default',
      vibrate: true
    }.merge(notification)

    data[:deeplink] = "kivach-recipes://#{deeplink}" if deeplink.present?

    payload = {
      to: "/topics/#{token}",
      priority: 'high',
      notification: notification,
      data: data
    }
    response = FCM_ANDPUSH.push(payload)

    retry_after = response.headers['Retry-After']
    self.class.perform_in(retry_after.to_i, user_id, deeplink, notification, data) if retry_after.present?
  end
end
