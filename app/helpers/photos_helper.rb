module PhotosHelper
  ICON_CLASSES = {
    twitter: 'icon-twitter',
    facebook: 'icon-facebook',
    google_oauth2: 'icon-google-plus',
    instagram: 'icon-instagram',
    foursquare: 'icon-foursquare'
  }
  def icon_class provider
    ICON_CLASSES[provider.to_sym] || 'icon-question'
  end
end
