class BusAssignmentSerializer < ActiveModel::Serializer
  attributes :student_name,
             :latitude,
             :longitude
end
