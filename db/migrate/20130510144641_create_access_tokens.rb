class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :access_tokens do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :name
      t.string :token
      t.string :secret
      t.timestamps
    end
  end
end
