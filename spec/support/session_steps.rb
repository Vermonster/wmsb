module SessionSteps
  def sign_in(credentials = {})
    stub_contact_id_api [200, {}, '"759393"']
    stub_assignments_api [200, {}, [].to_json]

    credentials.reverse_merge!(
      family_name: 'Stark',
      student_number: '1',
      date_of_birth: 10.years.ago
    )

    dob = credentials[:date_of_birth]

    visit root_path

    fill_in 'contact_id_family_name', with: credentials[:family_name]
    fill_in 'contact_id_student_number', with: credentials[:student_number]
    select dob.year.to_s, from: 'contact_id_date_of_birth_1i'
    select dob.strftime('%B'), from: 'contact_id_date_of_birth_2i'
    select dob.day.to_s, from: 'contact_id_date_of_birth_3i'
    click_button 'Sign In'
  end
end
