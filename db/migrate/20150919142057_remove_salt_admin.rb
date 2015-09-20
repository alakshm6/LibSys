class RemoveSaltAdmin < ActiveRecord::Migration
  def self.up
    remove_column :admins, :salt
  end

  def self.down
    add_column :admins, :salt, :string
  end
end
