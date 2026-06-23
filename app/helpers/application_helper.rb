module ApplicationHelper
  JST_ZONE = 'Asia/Tokyo'

  def jst_datetime(time)
    time&.in_time_zone(JST_ZONE)&.strftime('%Y-%m-%d %H:%M JST')
  end

  def jst_datetime_range(start_time, end_time)
    return jst_datetime(start_time) if start_time.blank? || end_time.blank? || start_time == end_time

    "#{jst_datetime(start_time)} 〜 #{jst_datetime(end_time)}"
  end
end
