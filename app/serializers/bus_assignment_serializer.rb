class BusAssignmentSerializer < ActiveModel::Serializer
  attributes :token,
             :student_name,
             :latitude,
             :longitude,
             :last_updated_at

  def token
    Digest::SHA512.hexdigest(object.student_number)
  end

  def last_updated_at
    object.last_updated_at.strftime('%B %e, %l:%M:%S %P')
  end
end
