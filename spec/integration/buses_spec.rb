require 'spec_helper'

feature 'View buses' do
  scenario 'lists student names' do
    assignments = [
      bus_assignments_response(
        BusNumber: '1',
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Aria',
        studentlastname: 'Stark'
      ),
      bus_assignments_response(
        BusNumber: '2',
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Sansa',
        studentlastname: 'Stark'
      )
    ]

    bus_one_location = bus_location_response(
      bus_id: '1',
      latitude: 42.01,
      longitude: -71.01
    )

    bus_two_location = bus_location_response(
      bus_id: '2',
      latitude: 42.02,
      longitude: -71.02
    )

    stub_assignments_api [200, {}, assignments.to_json]
    stub_zonar_api [200, {}, bus_one_location]
    stub_zonar_api [200, {}, bus_two_location]

    sign_in

    current_path.should eq buses_path

    page.should have_link 'Aria Stark'
    page.should have_link 'Sansa Stark'
  end
end
