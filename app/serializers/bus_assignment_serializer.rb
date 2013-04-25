class BusAssignmentSerializer < ActiveModel::Serializer
  TRIP_DIRECTIONS = {
    'arrival'   => 'School',
    'departure' => 'Home'
  }.freeze

  attributes :token,
             :student_name,
             :bus_number,
             :latitude,
             :longitude,
             :last_updated_at,
             :destination,
             :history

  def token
    Digest::SHA512.hexdigest(object.student_number)
  end

  def last_updated_at
    object.last_updated_at.strftime('%B %e, %l:%M %P')
  end

  def destination
    TRIP_DIRECTIONS[object.trip_flag]
  end
end
