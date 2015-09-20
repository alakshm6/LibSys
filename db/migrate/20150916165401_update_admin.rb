class UpdateAdmin < ActiveRecord::Migration
  def change
    rename_column(:Admins,:encrypted_password,:password)
    add_column(:Admins,:password_digest,:string)
  end
end
