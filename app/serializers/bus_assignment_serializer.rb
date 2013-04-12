class BusAssignmentSerializer < ActiveModel::Serializer
  attributes :token,
             :student_name,
             :latitude,
             :longitude

  def token
    Digest::SHA512.hexdigest(object.student_number)
  end
end
