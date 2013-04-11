require 'spec_helper'

feature 'Sessions' do
  scenario 'require student number, family name and date of birth' do
    stub_contact_id_api [200, {}, '"759393"']
    stub_assignments_api [200, {}, [].to_json]

    visit root_path

    fill_in 'session_family_name', with: 'Stark'
    fill_in 'session_student_number', with: '1'
    fill_in 'session_date_of_birth', with: '10/30/2010'
    click_button 'Sign In'

    current_path.should eq buses_path
  end

  scenario 'expire after 4 hours' do
    sign_in

    current_path.should eq buses_path

    visit buses_path

    current_path.should eq buses_path

    Timecop.travel(4.hours.from_now)

    visit buses_path

    current_path.should eq root_path
    notifications.should have_content 'Your session has expired'
  end
end
