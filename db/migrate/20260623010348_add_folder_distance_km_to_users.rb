class AddFolderDistanceKmToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :folder_distance_km, :decimal, precision: 5, scale: 2, null: false, default: 3.0
  end
end
