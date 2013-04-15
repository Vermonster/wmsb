class ApplicationController < ActionController::Base
  protect_from_forgery

  if ENV['ENABLE_HTTP_BASIC_AUTH']
    http_basic_authenticate_with :realm => 'WMSB', :name => ENV['HTTP_BASIC_AUTH_NAME'], :password => ENV['HTTP_BASIC_AUTH_PASSWORD']
  end
end
