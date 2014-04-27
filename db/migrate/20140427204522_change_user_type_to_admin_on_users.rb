class ChangeUserTypeToAdminOnUsers < ActiveRecord::Migration
  def change
    remove_column :users, :user_type
    add_column :users, :admin, :boolean, default: false
  end
end
