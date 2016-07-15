class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :email
      t.string :phone

      t.timestamps null: false
    end
  end
end
