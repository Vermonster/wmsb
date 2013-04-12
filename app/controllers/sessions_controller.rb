class SessionsController < ApplicationController
  def create
    contact = ContactId.find(
      family_name: params[:family_name],
      student_number: params[:student_number],
      date_of_birth: params[:date_of_birth]
    )

    if contact.errors.any?
      redirect_to :root, alert: contact.errors.full_messages.first
    else
      cookies[:current_assignment] = {
        value: Digest::SHA512.hexdigest(params[:student_number]),
        secure: true,
        path: buses_path
      }

      session[:contact_id]     = contact.contact_id
      session[:signed_in_at]   = Time.zone.now.to_s

      redirect_to :buses
    end
  end
end
