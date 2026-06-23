class CreatePhotos < ActiveRecord::Migration[7.2]
  def change
    create_table :photos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :photo_session, null: false, foreign_key: true
      t.string :title
      t.datetime :captured_at
      t.decimal :latitude
      t.decimal :longitude
      t.string :camera
      t.string :lens
      t.integer :iso
      t.string :aperture
      t.string :shutter_speed
      t.string :focal_length
      t.boolean :has_gps
      t.json :metadata

      t.timestamps
    end
  end
end
