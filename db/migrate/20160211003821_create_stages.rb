class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :title
      t.string :code, limit: 2
      t.integer :seq
      t.references :festival, index: true

      t.timestamps null: false
    end
    add_foreign_key :stages, :festivals
  end
end
