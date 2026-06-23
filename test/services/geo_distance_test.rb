require 'test_helper'

class GeoDistanceTest < ActiveSupport::TestCase
  test 'calculates kilometers between nearby coordinates' do
    distance = GeoDistance.kilometers_between(35.6812, 139.7671, 35.6900, 139.7700)

    assert_in_delta 1.0, distance, 0.2
  end

  test 'returns zero for the same coordinate' do
    distance = GeoDistance.kilometers_between(35.6812, 139.7671, 35.6812, 139.7671)

    assert_in_delta 0.0, distance, 0.001
  end
end
