class ApplicationController < ActionController::Base
  include ControllerHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if Rails.env.production?
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    rescue_from ActionController::RoutingError, :with => :render_404
    rescue_from Exception, :with => :render_500
  end

  {
    404 => { log: :info  }.ninja,
    403 => { log: :info  }.ninja,
    500 => { log: :error }.ninja
  }.each do |(status, option)|
    define_method("render_#{status}",
                  -> (exception = nil) {
                    if exception
                      logger.send(option.log, "Rendering #{status} with exception: #{exception.message}")
                    end
                    
                    render :template => "errors/#{status}", :status => status, :layout => 'application', :content_type => 'text/html'
                  });
  end
end
