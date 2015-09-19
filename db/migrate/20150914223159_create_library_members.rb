class CreateLibraryMembers < ActiveRecord::Migration
  def change
    create_table :library_members do |t|
      t.string :email
      t.string :name
      t.string :encrypted_password
      t.string :salt

      t.timestamps null: false
    end
  end
end
