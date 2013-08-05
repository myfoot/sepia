module Paginate
  extend ActiveSupport::Concern

  included do
    before_action :validate_page, only: [:index]
  end  

  def validate_page
    params[:page] = 1 if (params[:page].try(:to_i) || 0) < 1
  end
end
