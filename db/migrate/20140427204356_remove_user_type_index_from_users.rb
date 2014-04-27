class RemoveUserTypeIndexFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :user_type
  end
end
