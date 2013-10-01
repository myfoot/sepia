class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.boolean :public, null: false, default: false
      t.timestamps
    end
  end
end
