class CreateFestivals < ActiveRecord::Migration
  def change
    create_table :festivals do |t|
    	t.date    :startdate
      t.integer :days
      t.date    :scheduledate
      t.string  :year
      t.string  :title
      t.integer :major
      t.integer :minor
      t.boolean :active
      
      t.timestamps null: false
    end
  end
end
