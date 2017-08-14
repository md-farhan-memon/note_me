class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to main_app.root_url, notice: exception.message }
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    render file: "#{Rails.root}/public/404", layout: true, status: :not_found
  end
end
