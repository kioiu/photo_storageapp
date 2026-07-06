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
      photos: [
        {
          key: 'tokyo_station_evening',
          image: 'tokyo_station_evening.png',
          attributes: {
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
          }
        },
        {
          key: 'tokyo_station_no_gps',
          image: 'tokyo_station_no_gps.png',
          attributes: {
            title: '駅舎を見上げる一枚',
            captured_at: Time.zone.local(2026, 4, 30, 17, 31),
            latitude: nil,
            longitude: nil,
            camera: 'Canon EOS R6',
            lens: 'RF 35mm F1.8 MACRO IS STM',
            iso: 200,
            aperture: 'f/2.8',
            shutter_speed: '1/200',
            focal_length: '35mm',
            has_gps: false
          }
        }
      ]
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
      photos: [
        {
          key: 'ueno_museum_walk',
          image: 'ueno_museum_walk.png',
          attributes: {
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
          }
        },
        {
          key: 'ueno_gallery_no_gps',
          image: 'ueno_gallery_no_gps.png',
          attributes: {
            title: '廊下のポスター',
            captured_at: Time.zone.local(2026, 5, 3, 11, 21),
            latitude: nil,
            longitude: nil,
            camera: 'Nikon Z6',
            lens: 'NIKKOR Z 40mm f/2',
            iso: 640,
            aperture: 'f/2.8',
            shutter_speed: '1/100',
            focal_length: '40mm',
            has_gps: false
          }
        }
      ]
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
      photos: [
        {
          key: 'yokohama_harbor',
          image: 'yokohama_harbor.png',
          attributes: {
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
          }
        },
        {
          key: 'yokohama_deck_no_gps',
          image: 'yokohama_deck_no_gps.png',
          attributes: {
            title: 'デッキからの街灯',
            captured_at: Time.zone.local(2026, 5, 18, 19, 48),
            latitude: nil,
            longitude: nil,
            camera: 'FUJIFILM X-T5',
            lens: 'XF 23mm F2 R WR',
            iso: 1000,
            aperture: 'f/2.8',
            shutter_speed: '1/80',
            focal_length: '23mm',
            has_gps: false
          }
        }
      ]
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
      photos: [
        {
          key: 'kamakura_cafe',
          image: 'kamakura_cafe.png',
          attributes: {
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
          }
        },
        {
          key: 'kamakura_street_no_gps',
          image: 'kamakura_street_no_gps.png',
          attributes: {
            title: '小町通りの午後',
            captured_at: Time.zone.local(2026, 6, 1, 14, 33),
            latitude: nil,
            longitude: nil,
            camera: 'Sony α7 IV',
            lens: 'FE 55mm F1.8 ZA',
            iso: 250,
            aperture: 'f/2.5',
            shutter_speed: '1/250',
            focal_length: '55mm',
            has_gps: false
          }
        }
      ]
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
      photos: [
        {
          key: 'mashiko_pottery',
          image: 'mashiko_pottery.png',
          attributes: {
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
          }
        },
        {
          key: 'mashiko_market_no_gps',
          image: 'mashiko_market_no_gps.png',
          attributes: {
            title: '露店の器',
            captured_at: Time.zone.local(2026, 6, 12, 10, 42),
            latitude: nil,
            longitude: nil,
            camera: 'Canon EOS R6',
            lens: 'RF 85mm F2 MACRO IS STM',
            iso: 320,
            aperture: 'f/3.2',
            shutter_speed: '1/200',
            focal_length: '85mm',
            has_gps: false
          }
        }
      ]
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

    sample[:photos].each do |photo_sample|
      ensure_photo!(session, photo_sample)
    end
  end

  def ensure_photo!(session, photo_sample)
    photo = user.photos.find_or_initialize_by(
      title: photo_sample[:attributes][:title],
      photo_session: session
    )
    photo.assign_attributes(photo_sample[:attributes].merge(metadata: { sample_key: photo_sample[:key] }))
    attach_image(photo, photo_sample[:image])
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
