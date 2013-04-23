class ApplicationController < ActionController::Base
  protect_from_forgery

  if ENV['ENABLE_HTTP_BASIC_AUTH']
    http_basic_authenticate_with :realm => 'WMSB', :name => ENV['HTTP_BASIC_AUTH_NAME'], :password => ENV['HTTP_BASIC_AUTH_PASSWORD']
  end

  private

  def session_exists?
    session[:contact_id].present?
  end

  def session_expired?
    timestamp = (session[:signed_in_at] and Time.zone.parse(session[:signed_in_at]))
    timestamp.present? && Time.zone.now - timestamp > 4.hours
  end
end
