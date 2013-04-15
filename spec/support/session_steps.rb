module SessionSteps
  def sign_in
    stub_contact_id_api [200, {}, '"759393"']
    stub_assignments_api [200, {}, [].to_json]

    year = 10.years.ago.year.to_s

    visit root_path

    fill_in 'session_family_name', with: 'Stark'
    fill_in 'session_student_number', with: '1'
    select year, from: 'session_date_of_birth_1i'
    select 'October', from: 'session_date_of_birth_2i'
    select '30', from: 'session_date_of_birth_3i'
    click_button 'Sign In'
  end
end
