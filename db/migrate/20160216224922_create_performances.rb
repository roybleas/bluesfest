class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.integer :daynumber
      t.string :duration
      t.time :starttime
      t.string :title
      t.string :scheduleversion
      t.references :festival, index: true
      t.references :artist, index: true
      t.references :stage, index: true

      t.timestamps null: false
    end
    add_foreign_key :performances, :festivals
    add_foreign_key :performances, :artists
    add_foreign_key :performances, :stages
  end
end
