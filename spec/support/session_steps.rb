module SessionSteps
  def sign_in
    stub_contact_id_api [200, {}, '"759393"']
    stub_assignments_api [200, {}, [].to_json]

    visit root_path

    fill_in 'family_name', with: 'Stark'
    fill_in 'student_number', with: '1'
    fill_in 'date_of_birth', with: '10/30/2010'
    click_button 'Sign In'
  end
end
