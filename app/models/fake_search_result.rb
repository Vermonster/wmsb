class FakeSearchResult
  def errors
    []
  end

  def assignments_without_gps_data
    []
  end

  def assignments_with_gps_data
    [
      {latitude: 42.358, longitude: -71.06},
      {latitude: 42.38, longitude: -71.01}
    ]
  end
end
