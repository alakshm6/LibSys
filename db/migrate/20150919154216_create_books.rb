class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :ISBN
      t.string :title
      t.text :description
      t.string :author
      t.string :status

      t.timestamps null: false
    end
  end
end
