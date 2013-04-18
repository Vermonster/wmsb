class SessionsController < ApplicationController
  def create
    contact = ContactId.find(session_params)

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

  def destroy
    cookies.delete(:current_assignment)
    session.delete(:contact_id)
    session.delete(:signed_in_at)

    redirect_to root_path, notice: 'You have been logged out'
  end

  private

  def session_params
    @session_params ||= begin
      hash = params[:session].dup

      date_of_birth = Time.zone.local(
        hash.delete('date_of_birth(1i)').to_i,
        hash.delete('date_of_birth(2i)').to_i,
        hash.delete('date_of_birth(3i)').to_i
      )
      hash[:date_of_birth] = date_of_birth.strftime('%m/%d/%Y')

      hash
    end
  end
end
