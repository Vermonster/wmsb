require 'spec_helper'

feature 'View buses' do
  scenario 'lists student names' do
    assignments = [
      attributes_for(
        :bus_assignment_response,
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Aria',
        studentlastname: 'Stark'
      ),
      attributes_for(
        :bus_assignment_response,
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Sansa',
        studentlastname: 'Stark'
      )
    ]

    stub_assignments_api [200, {}, assignments.to_json]

    sign_in

    current_path.should eq buses_path

    page.should have_content 'Aria Stark'
    page.should have_content 'Sansa Stark'
  end
end
