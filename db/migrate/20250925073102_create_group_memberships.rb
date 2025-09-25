class CreateGroupMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :group_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :debt_project, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
