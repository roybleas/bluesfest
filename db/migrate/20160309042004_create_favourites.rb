class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.integer :user_id
      t.references :artist, index: true

      t.timestamps null: false
    end
    add_foreign_key :favourites, :artists
  end
end
