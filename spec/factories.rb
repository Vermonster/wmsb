FactoryGirl.define do
  sequence :string do |n|
    "string%09d" % n
  end

  sequence :number do |n|
    n
  end

  sequence :email do |n|
    "user%d@example.com" % n
  end

  factory :bus_assignment_response, class: Struct do
    BusNumber { generate(:string) }
    StudentNo { generate(:string) }
    days 'MTWHF'
    parentfirstname { generate(:string) }
    parentlastname { generate(:string) }
    studentfirstname { generate(:string) }
    studentlastname { generate(:string) }
  end
end
