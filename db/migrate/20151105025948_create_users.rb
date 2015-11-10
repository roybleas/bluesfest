class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :screen_name
      t.string :password_digest
      t.string :remember_digest
      t.boolean :admin

      t.timestamps null: false
    end
  end
end
