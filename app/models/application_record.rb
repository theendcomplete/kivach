class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_destroy do
    throw :abort if invalid?(:destroy)
  end

  def generate_payload_old(payload)
    Hash[payload.map { |k| [k, self[k]] }]
    data = {}
    payload.each do |k, _|
      data[k] = self[k]
    end
    data
  end

  def self.safe_create!(payload)
    obj = create! payload
    obj.diff_create! payload
    obj
  end

  def safe_update!(payload)
    payload_old = generate_payload_old payload
    if payload_old != payload
      update! payload
      diff_create! payload, payload_old
      self
    end
  end

  def safe_save
    save!
    diff_create! self
    self
  end

  def diff_create!(payload, payload_old = nil)
    # Method for overloading
  end

  def sanitize_title
    self.title = title.strip.gsub(/[\u0000-\u001F\u007F-\u00FF\s]+/, ' ')
  end
end
