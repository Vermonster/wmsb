require 'spec_helper'

feature 'View buses', js: true do
  scenario 'lists student names' do
    pending "Broken while trying to get things working locally"
    assignments = [
      bus_assignments_response(
        BusNumber: '1',
        StudentNo: '123',
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Aria',
        studentlastname: 'Stark'
      ),
      bus_assignments_response(
        BusNumber: '2',
        StudentNo: '456',
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Sansa',
        studentlastname: 'Stark'
      )
    ]

    bus_one_location = bus_history_response(
      lat: 42.01,
      lng: -71.01,
      time: Time.zone.local(2010, 10, 30, 10, 30)
    )

    bus_two_location = bus_history_response(
      lat: 42.02,
      lng: -71.02,
      time: Time.zone.local(2010, 10, 30, 10, 45)
    )

    stub_assignments_api [200, {}, assignments.to_json]
    stub_zonar_history_api [200, {}, [bus_one_location]]
    stub_zonar_history_api [200, {}, [bus_two_location]]

    sign_in student_number: '123'

    current_path.should eq buses_path

    page.should have_selected_student 'Aria Stark'
    page.should have_content 'Oct 30, 10:30 am'
    page.should have_content 'Bus number: 1'
    page.should_not have_student_names_list

    selected_student('Aria Stark').click

    within student_names_list do
      student_element('Sansa Stark').click
    end

    page.should have_selected_student 'Sansa Stark'
    page.should have_content 'Oct 30, 10:45 am'
    page.should have_content 'Bus number: 2'
    page.should_not have_student_names_list
  end

  it 'does not present a selector for one student' do
    assignment = bus_assignments_response(student_number: '123')
    stub_assignments_api [200, {}, ]
    stub_zonar_history_api [200, {}, [bus_history_response]]

    sign_in student_number: '123'

    current_path.should eq buses_path

    page.should_not have_css '.select-students'
  end

  it 'filters out buses without location information' do
    assignments = [
      bus_assignments_response(
        BusNumber: '1',
        StudentNo: '123',
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Aria',
        studentlastname: 'Stark'
      ),
      bus_assignments_response(
        BusNumber: '2',
        StudentNo: '456',
        parentfirstname: 'Ned',
        parentlastname: 'Stark',
        studentfirstname: 'Sansa',
        studentlastname: 'Stark'
      )
    ]

    bus_one_location = bus_history_response(
      lat: 42.01,
      lng: -71.01,
      time: Time.zone.local(2010, 10, 30, 10, 30)
    )

    bus_two_location = bus_history_response(
      lat: 42.02,
      lng: -71.02,
      time: Time.zone.local(2010, 10, 30, 10, 45)
    )

    stub_assignments_api [200, {}, assignments.to_json]
    stub_zonar_history_api [200, {}, [bus_one_location]]
    stub_zonar_history_api [200, {}, []]
    stub_zonar_api [200, {}, "<currentlocations>\n</currentlocations>"]

    sign_in student_number: '123'

    current_path.should eq buses_path

    page.should have_selected_student 'Aria Stark'

    # Should not render student name as a selector
    page.should_not have_css '.select-students'

    notifications.should have_content " no GPS information is currently available for Sansa Stark"
  end
end
