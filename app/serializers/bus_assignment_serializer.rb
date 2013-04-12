class BusAssignmentSerializer < ActiveModel::Serializer
  attributes :student_name,
             :latitude,
             :longitude,
             :selected

  def selected
    options[:current_student_number] == object.student_number
  end
end
