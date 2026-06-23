require 'exifr/jpeg'

class PhotoMetadataExtractor
  def initialize(photo, upload)
    @photo = photo
    @upload = upload
  end

  def apply!
    read_exif_from_upload
  rescue EXIFR::MalformedJPEG, EXIFR::MalformedImage, NoMethodError, Errno::ENOENT
    @photo.metadata ||= {}
  ensure
    @photo.has_gps = @photo.latitude.present? && @photo.longitude.present?
    @photo.captured_at ||= Time.current
    @photo.title ||= upload_filename
  end

  private

  def read_exif_from_upload
    path = upload_path
    return if path.blank?

    exif = EXIFR::JPEG.new(path)
    apply_exif(exif) if exif.exif?
  end

  def upload_path
    return @upload.tempfile.path if @upload.respond_to?(:tempfile) && @upload.tempfile.respond_to?(:path)
    return @upload.path if @upload.respond_to?(:path)
  end

  def upload_filename
    filename = if @upload.respond_to?(:original_filename)
      @upload.original_filename
    elsif @upload.respond_to?(:filename)
      @upload.filename.to_s
    end

    File.basename(filename.to_s, '.*').presence || 'Untitled photo'
  end

  def apply_exif(exif)
    @photo.captured_at = value(exif, :date_time_original) || value(exif, :date_time) || @photo.captured_at
    @photo.camera = [value(exif, :make), value(exif, :model)].compact.join(' ').presence
    @photo.lens = value(exif, :lens_model) || value(exif, :lens)
    @photo.iso = Array(value(exif, :iso_speed_ratings)).compact.first
    @photo.aperture = format_aperture(value(exif, :f_number) || value(exif, :aperture_value))
    @photo.shutter_speed = format_shutter(value(exif, :exposure_time))
    @photo.focal_length = format_focal_length(value(exif, :focal_length))
    apply_gps(exif)

    @photo.metadata = {
      width: value(exif, :width),
      height: value(exif, :height),
      software: value(exif, :software)
    }.compact
  end

  def apply_gps(exif)
    gps = value(exif, :gps)
    return unless gps

    @photo.latitude = value(gps, :latitude)
    @photo.longitude = value(gps, :longitude)
  end

  def value(object, method_name)
    return unless object.respond_to?(method_name)

    object.public_send(method_name)
  end

  def format_aperture(number)
    return if number.blank?

    "f/#{format_number(number)}"
  end

  def format_shutter(number)
    return if number.blank?

    rational = number.to_r
    return "1/#{(1 / rational).round}" if rational.positive? && rational < 1

    "#{format_number(number)}s"
  end

  def format_focal_length(number)
    return if number.blank?

    "#{format_number(number)}mm"
  end

  def format_number(number)
    float = number.to_f
    float == float.round ? float.round.to_s : float.round(1).to_s
  end
end
