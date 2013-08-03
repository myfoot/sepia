class ChangeMessageTypeInPhotos < ActiveRecord::Migration
  def change
    change_column :photos, :message, :text
  end
end
