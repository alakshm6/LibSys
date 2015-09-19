class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :email
      t.string :name
      t.string :encrypted_password
      t.string :salt
      t.boolean :pre_configured

      t.timestamps
    end
  end
end
