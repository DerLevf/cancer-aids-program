class AddUniqueIndexToUsersUsername < ActiveRecord::Migration[7.1]
  def change
    # Add unique index for username
    add_index :users, :username, unique: true
    
    # Add unique index for email (good practice, if not already done)
    add_index :users, :email, unique: true
  end
end