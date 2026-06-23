class CreatePhotoSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :photo_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.datetime :started_at
      t.decimal :latitude
      t.decimal :longitude
      t.string :classification

      t.timestamps
    end
  end
end
