class RemovePasswordAdmin < ActiveRecord::Migration
  def self.up
    remove_column :admins, :password
  end

  def self.down
    add_column :admins, :password, :string
  end
end
