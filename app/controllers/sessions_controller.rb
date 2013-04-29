class SessionsController < ApplicationController
  before_filter :redirect_to_buses, only: :new

  def new
    @session = ContactId.new
  end

  def create
    @session = ContactId.new(params[:contact_id])

    if @session.valid? && @session.authenticate!
      cookies[:current_assignment] = {
        value: Digest::SHA512.hexdigest(@session.student_number),
        secure: true
      }

      session[:contact_id]   = @session.contact_id
      session[:signed_in_at] = Time.zone.now.to_s

      redirect_to :buses
    else
      flash.now.alert = 'There was a problem signing you in.'
      render :new
    end
  end

  def destroy
    cookies.delete(:current_assignment)
    session.delete(:contact_id)
    session.delete(:signed_in_at)

    redirect_to root_path, notice: 'You have been logged out'
  end

  private

  def redirect_to_buses
    if session_exists? && !session_expired?
      redirect_to :buses
    end
  end
end
