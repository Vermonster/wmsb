class SessionsController < ApplicationController
  def create
    contact = ContactId.find(params[:session])

    if contact.errors.any?
      redirect_to :root, alert: contact.errors.full_messages.first
    else
      cookies[:current_assignment] = {
        value: Digest::SHA512.hexdigest(params[:session][:student_number]),
        secure: true,
        path: buses_path
      }

      session[:contact_id]     = contact.contact_id
      session[:signed_in_at]   = Time.zone.now.to_s

      redirect_to :buses
    end
  end
end
