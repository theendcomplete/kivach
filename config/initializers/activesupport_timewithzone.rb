class ActiveSupport::TimeWithZone
  def as_json(_options = {})
    # strftime('%FT%T%:z')
    to_time.iso8601
  end
end
