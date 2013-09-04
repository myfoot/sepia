module ApplicationHelper
  # TODO 例外処理
  def format_time(time, format="%Y-%m-%d %H:%M:%S")
    time_str = time.is_a?(String) ? time : time.to_s
    Time.parse(time_str).localtime.strftime(format)
  end

  def lazy_image_tag(path, options={})
    options['data-src'] = path
    image_tag('loader.gif', options)
  end
end
