module SessionSteps
  def sign_in
    stub_contact_id_api do |request|
      request.get('/bpswstr/Connect.svc/aspen_contact_id') { [200, {}, '"759393"'] }
    end

    visit root_path

    fill_in 'family_name', with: 'Stark'
    fill_in 'student_number', with: '1'
    fill_in 'date_of_birth', with: '10/30/2010'
    click_button 'Sign In'
  end
end
