class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :department_id
      t.string :phone
      t.string :email
      t.string :address
      t.date :start_date
      t.date :birthday
      t.integer :user_type

      t.timestamps
    end
    add_index :users, [:first_name, :last_name]
    add_index :users, :email, unique: true
    add_index :users, :department_id
    add_index :users, :user_type
  end
end
