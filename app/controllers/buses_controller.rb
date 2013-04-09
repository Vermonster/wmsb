class BusesController < ApplicationController
  before_filter :authenticate!

  private

  def authenticate!
    if Time.zone.now - signed_in_at > 4.hours
      session.delete(:contact_id)
      redirect_to :root, alert: 'Your session has expired.'
    elsif !session[:contact_id]
      redirect_to :root, alert: 'You need to sign in first.'
    end
  end

  def signed_in_at
    @signed_in_at ||= Time.zone.parse(session[:signed_in_at])
  end
end
