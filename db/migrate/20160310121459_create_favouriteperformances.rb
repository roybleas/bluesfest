class CreateFavouriteperformances < ActiveRecord::Migration
  def change
    create_table :favouriteperformances do |t|
      t.integer :performance_id
      t.boolean :active, default: true
      t.references :favourite, index: true

      t.timestamps null: false
    end
    add_foreign_key :favouriteperformances, :favourites
  end
end
