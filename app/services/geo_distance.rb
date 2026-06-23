class GeoDistance
  EARTH_RADIUS_KM = 6371.0

  def self.kilometers_between(from_latitude, from_longitude, to_latitude, to_longitude)
    new(from_latitude, from_longitude, to_latitude, to_longitude).kilometers
  end

  def initialize(from_latitude, from_longitude, to_latitude, to_longitude)
    @from_latitude = from_latitude.to_f
    @from_longitude = from_longitude.to_f
    @to_latitude = to_latitude.to_f
    @to_longitude = to_longitude.to_f
  end

  def kilometers
    latitude_delta = radians(@to_latitude - @from_latitude)
    longitude_delta = radians(@to_longitude - @from_longitude)
    from_latitude_radians = radians(@from_latitude)
    to_latitude_radians = radians(@to_latitude)

    a = Math.sin(latitude_delta / 2)**2 +
      Math.cos(from_latitude_radians) * Math.cos(to_latitude_radians) *
      Math.sin(longitude_delta / 2)**2

    2 * EARTH_RADIUS_KM * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  end

  private

  def radians(degrees)
    degrees * Math::PI / 180
  end
end
