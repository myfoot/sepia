module ApplicationHelper
  # TODO 例外処理
  def format_time(time, format="%Y-%m-%d %H:%M:%S")
    time_str = time.kind_of?(String) ? time : time.to_s
    Time.parse(time_str).localtime.strftime(format)
  end
end
