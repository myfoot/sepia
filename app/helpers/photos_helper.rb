module PhotosHelper
  def icon_class provider
    case provider.to_sym
    when :twitter
      'icon-twitter'
    when :facebook
      'icon-facebook'
    when :google_oauth2
      'icon-google-plus'
    when :instagram
      'icon-instagram'
    else
      'icon-question'
    end
  end
end
