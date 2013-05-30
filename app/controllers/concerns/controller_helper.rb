module ControllerHelper
  def safe_redirect path
    uri = URI.parse(path)
    redirect_to (uri.relative? || uri.host == request.host) ? path : root
  end
end
