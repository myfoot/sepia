module ApplicationHelper
  # TODO 例外処理
  def format_time(time, format="%Y-%m-%d %H:%M:%S")
    time_str = time.is_a?(String) ? time : time.to_s
    Time.parse(time_str).localtime.strftime(format)
  end
end
