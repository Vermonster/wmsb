class SessionsController < ApplicationController
  before_filter :redirect_to_buses, only: :new

  def new
    @session = ContactId.new
  end

  def create
    @session = ContactId.new(params[:contact_id])

    if @session.valid? && @session.authenticate!
      session[:contact_id]   = @session.contact_id
      session[:signed_in_at] = Time.zone.now.to_s
      session[:current_assignment] = Digest::SHA512.hexdigest(@session.student_number).first(20)

      redirect_to buses_path(anchor: session[:current_assignment])
    else
      flash.now.alert = 'There was a problem signing you in.'
      render :new
    end
  end

  def destroy
    session.delete(:current_assignment)
    session.delete(:contact_id)
    session.delete(:signed_in_at)

    redirect_to root_path, notice: 'You have been logged out'
  end

  private

  def redirect_to_buses
    if session_exists? && !session_expired?
      redirect_to buses_path(anchor: session[:current_assignment])
    end
  end
end
