class CreateCheckoutHistories < ActiveRecord::Migration
  def change
    create_table :checkout_histories do |t|
      t.string :email
      t.string :ISBN
      t.string :checkout_timestamp
      t.string :return_timestamp

      t.timestamps null: false
    end
  end
end
