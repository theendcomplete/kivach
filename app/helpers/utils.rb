module Utils
  module_function

  include ActionView::Helpers::DateHelper

  def mask_phone(phone)
    "#{phone[0..3]}***#{phone[-3..-1]}"
  end

  def format_datetime(datetime)
    date = datetime.to_date
    date_format = if date == Date.current
                    'сегодня'
                  elsif date == Date.yesterday
                    'вчера'
                  elsif date == Date.tomorrow
                    'завтра'
                  else
                    '%d %B'
    end
    time_format = '%R'
    datetime_format = "#{date_format} в #{time_format}"
    I18n.l datetime, format: datetime_format
  end
end
