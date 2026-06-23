class PhotoSessionClassifier
  TIME_WINDOW = 2.hours

  def initialize(user, photo, session_title: nil)
    @user = user
    @photo = photo
    @session_title = session_title.to_s.strip.presence
  end

  def call
    if @photo.has_gps?
      nearby_gps_session || create_gps_session
    else
      nearby_gps_session || date_session
    end
  end

  private

  def create_gps_session
    session = @user.photo_sessions.create!(
      title: gps_session_title,
      started_at: captured_time,
      latitude: @photo.latitude,
      longitude: @photo.longitude,
      classification: 'gps'
    )

    move_nearby_non_gps_photos_to(session)
    session
  end

  def gps_session_title
    @session_title || "GPS撮影 #{captured_time.in_time_zone('Asia/Tokyo').strftime('%Y-%m-%d %H:%M')}"
  end

  def nearby_gps_session
    sessions = @user.photo_sessions
      .gps
      .where(started_at: captured_time_window)
      .to_a

    @photo.has_gps? ? nearest_session_within_radius(sessions) : nearest_session_by_time(sessions)
  end

  def nearest_session_within_radius(sessions)
    sessions
      .map { |session| [session, distance_from_photo(session)] }
      .select { |_session, distance| distance <= folder_distance_km }
      .min_by { |_session, distance| distance }
      &.first
  end

  def nearest_session_by_time(sessions)
    sessions.min_by { |session| (session.started_at - captured_time).abs }
  end

  def date_session
    started_at = captured_time.beginning_of_day

    @user.photo_sessions.find_or_create_by!(classification: 'date', started_at: started_at) do |session|
      session.title = "#{started_at.in_time_zone('Asia/Tokyo').strftime('%Y-%m-%d')} の撮影"
    end
  end

  def move_nearby_non_gps_photos_to(session)
    old_sessions = []

    @user.photos
      .where(has_gps: false, captured_at: time_window_for(session.started_at))
      .includes(:photo_session)
      .find_each do |photo|
        old_sessions << photo.photo_session if photo.photo_session&.date?
        photo.update_columns(photo_session_id: session.id, updated_at: Time.current)
      end

    old_sessions.uniq.each do |old_session|
      old_session.destroy! if old_session.photos.reload.empty?
    end
  end

  def folder_distance_km
    @folder_distance_km ||= @user.folder_distance_km_value.to_f
  end

  def distance_from_photo(session)
    return Float::INFINITY unless session.display_location? && @photo.latitude.present? && @photo.longitude.present?

    GeoDistance.kilometers_between(
      @photo.latitude,
      @photo.longitude,
      session.display_latitude,
      session.display_longitude
    )
  end

  def captured_time_window
    time_window_for(captured_time)
  end

  def time_window_for(time)
    (time - TIME_WINDOW)..(time + TIME_WINDOW)
  end

  def captured_time
    @captured_time ||= @photo.captured_at || Time.current
  end
end
