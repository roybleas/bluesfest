class CreateArtistpages < ActiveRecord::Migration
  def change
    create_table :artistpages do |t|
      t.string :letterstart
      t.string :letterend
      t.string :title
      t.integer :seq
      t.references :festival, index: true

      t.timestamps null: false
    end
    add_foreign_key :artistpages, :festivals
  end
end
