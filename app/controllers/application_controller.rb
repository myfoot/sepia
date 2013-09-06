class ApplicationController < ActionController::Base
  include ControllerHelper
  include AsyncJob

  before_action :photo_collect

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env.production?
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from Exception, :with => :render_500
  end

  [404, 403, 500].each do |status|
    define_method("render_#{status}",
                  -> (exception = nil) {
                    if exception
                      logger.info "Rendering #{status} with exception: #{exception.message}"
                    end
                    
                    render :template => "errors/#{status}", :status => status, :layout => 'application', :content_type => 'text/html'
                  });
  end

  private
  def photo_collect
    schedule_photo_collect(current_user) if current_user
  end
end
