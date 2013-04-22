require 'spec_helper'

feature 'Sessions' do
  scenario 'require student number, family name and date of birth' do
    sign_in

    current_path.should eq buses_path

    click_link 'Logout'

    current_path.should eq root_path
    notifications.should have_content 'You have been logged out'

    visit buses_path

    current_path.should eq root_path
    notifications.should have_content 'You need to sign in first'
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

  scenario 'validates login fields' do
    visit root_path

    click_button 'Sign In'

    current_path.should eq login_path

    notifications.should have_content 'There was a problem signing you in'

    within login_form do
      page.should have_form_error text: 'must be entered', count: 3
    end
  end

  scenario 'handles bad login values' do
    stub_contact_id_api [400, {}, ""]

    sign_in

    current_path.should eq login_path

    notifications.should have_content 'There was a problem signing you in'

    within login_form do
      page.should have_field 'contact_id_family_name', with: 'Stark'
    end
  end
end
