module SessionSteps
  def sign_in
    stub_contact_id_api [200, {}, '"759393"']
    stub_assignments_api [200, {}, [].to_json]

    visit root_path

    fill_in 'session_family_name', with: 'Stark'
    fill_in 'session_student_number', with: '1'
    fill_in 'session_date_of_birth', with: '10/30/2010'
    click_button 'Sign In'
  end
end
