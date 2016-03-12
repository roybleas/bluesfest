class AddIndexToFavourites < ActiveRecord::Migration
  def change
  	add_index :favourites, [:artist_id, :user_id], unique: true
  end
  
end
