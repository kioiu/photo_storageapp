class SamplePortfolioBuilder
  SAMPLE_IMAGE_DIR = Rails.root.join('db/seeds/sample_images')

  SAMPLES = [
    {
      key: 'tokyo_station_evening',
      session: {
        title: '東京駅 夕景スナップ',
        started_at: Time.zone.local(2026, 4, 30, 17, 20),
        latitude: 35.681236,
        longitude: 139.767125,
        classification: 'gps'
      },
      photo: {
        title: '丸の内駅前広場',
        captured_at: Time.zone.local(2026, 4, 30, 17, 22),
        latitude: 35.681236,
        longitude: 139.767125,
        camera: 'Apple iPhone 15',
        lens: 'iPhone 15 back dual wide camera',
        iso: 64,
        aperture: 'f/1.6',
        shutter_speed: '1/240',
        focal_length: '5.96mm',
        has_gps: true
      },
      image: 'tokyo_station_evening.png'
    },
    {
      key: 'ueno_museum_walk',
      session: {
        title: '上野 美術館散歩',
        started_at: Time.zone.local(2026, 5, 3, 11, 5),
        latitude: 35.715298,
        longitude: 139.774535,
        classification: 'gps'
      },
      photo: {
        title: '展示室前の光',
        captured_at: Time.zone.local(2026, 5, 3, 11, 8),
        latitude: 35.715298,
        longitude: 139.774535,
        camera: 'Sony α7 IV',
        lens: 'FE 35mm F1.8',
        iso: 400,
        aperture: 'f/2.8',
        shutter_speed: '1/125',
        focal_length: '35mm',
        has_gps: true
      },
      image: 'ueno_museum_walk.png'
    },
    {
      key: 'yokohama_harbor',
      session: {
        title: '横浜 港の夜景',
        started_at: Time.zone.local(2026, 5, 18, 19, 32),
        latitude: 35.454954,
        longitude: 139.631385,
        classification: 'gps'
      },
      photo: {
        title: '赤レンガ倉庫ライトアップ',
        captured_at: Time.zone.local(2026, 5, 18, 19, 35),
        latitude: 35.454954,
        longitude: 139.631385,
        camera: 'Nikon Z6',
        lens: 'NIKKOR Z 24-70mm f/4 S',
        iso: 800,
        aperture: 'f/4',
        shutter_speed: '1/60',
        focal_length: '42mm',
        has_gps: true
      },
      image: 'yokohama_harbor.png'
    },
    {
      key: 'kamakura_cafe',
      session: {
        title: '鎌倉 カフェ巡り',
        started_at: Time.zone.local(2026, 6, 1, 14, 10),
        latitude: 35.319225,
        longitude: 139.546686,
        classification: 'date'
      },
      photo: {
        title: '窓際のテーブル',
        captured_at: Time.zone.local(2026, 6, 1, 14, 16),
        latitude: nil,
        longitude: nil,
        camera: 'Canon EOS R6',
        lens: 'RF 50mm F1.8 STM',
        iso: 320,
        aperture: 'f/2.2',
        shutter_speed: '1/160',
        focal_length: '50mm',
        has_gps: false
      },
      image: 'kamakura_cafe.png'
    },
    {
      key: 'mashiko_pottery',
      session: {
        title: '益子 陶器市',
        started_at: Time.zone.local(2026, 6, 12, 10, 25),
        latitude: 36.467215,
        longitude: 140.091233,
        classification: 'gps'
      },
      photo: {
        title: '白い器の並ぶ棚',
        captured_at: Time.zone.local(2026, 6, 12, 10, 28),
        latitude: 36.467215,
        longitude: 140.091233,
        camera: 'FUJIFILM X-T5',
        lens: 'XF 23mm F2 R WR',
        iso: 250,
        aperture: 'f/2.8',
        shutter_speed: '1/250',
        focal_length: '23mm',
        has_gps: true
      },
      image: 'mashiko_pottery.png'
    }
  ].freeze

  def initialize(user)
    @user = user
  end

  def ensure!
    SAMPLES.each { |sample| ensure_sample!(sample) }
  end

  private

  attr_reader :user

  def ensure_sample!(sample)
    session = user.photo_sessions.find_or_initialize_by(
      title: sample[:session][:title],
      classification: sample[:session][:classification]
    )
    session.assign_attributes(sample[:session])
    session.save!

    photo = user.photos.find_or_initialize_by(
      title: sample[:photo][:title],
      photo_session: session
    )
    photo.assign_attributes(sample[:photo].merge(metadata: { sample_key: sample[:key] }))
    attach_image(photo, sample[:image])
    photo.save!
  end

  def attach_image(photo, filename)
    return if photo.image.attached?

    image_path = SAMPLE_IMAGE_DIR.join(filename)
    photo.image.attach(
      io: File.open(image_path, 'rb'),
      filename: filename,
      content_type: 'image/png'
    )
  end
end
