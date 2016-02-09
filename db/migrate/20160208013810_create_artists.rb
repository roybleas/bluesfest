class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :code
      t.boolean :active, default: false
      t.date :extractdate
      t.references :festival, index: true

      t.timestamps null: false
    end
    add_foreign_key :artists, :festivals
  end
end
