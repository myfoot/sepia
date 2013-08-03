class CreateAlbumsPhotos < ActiveRecord::Migration
  def change
    create_table :albums_photos do |t|
      t.integer :album_id, null: false
      t.integer :photo_id, null: false
      t.timestamps
    end
  end
end
