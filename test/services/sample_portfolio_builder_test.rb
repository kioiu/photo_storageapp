require 'test_helper'

class SamplePortfolioBuilderTest < ActiveSupport::TestCase
  test 'creates portfolio sample photos and sessions once' do
    user = User.create!(
      name: 'Portfolio Guest',
      email: 'portfolio-test@example.local',
      password: 'password',
      guest: true
    )

    builder = SamplePortfolioBuilder.new(user)

    assert_difference -> { user.photo_sessions.count }, 5 do
      assert_difference -> { user.photos.count }, 5 do
        builder.ensure!
      end
    end

    assert user.photos.all? { |photo| photo.image.attached? }

    assert_no_difference -> { user.photo_sessions.count } do
      assert_no_difference -> { user.photos.count } do
        builder.ensure!
      end
    end
  end
end
