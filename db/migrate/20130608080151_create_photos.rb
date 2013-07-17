class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :user_id, null: false
      t.string :platform_id, null: false
      t.string :provider, null: false
      t.string :format, null: false
      t.string :message
      t.integer :width
      t.integer :height
      t.datetime :posted_at
      t.timestamps
    end
  end
end
