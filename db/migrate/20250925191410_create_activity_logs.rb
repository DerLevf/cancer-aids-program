class CreateActivityLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :debt_project, null: true, foreign_key: true # Change null: false to null: true
      t.string :action
      t.text :details
      t.references :trackable, polymorphic: true, null: true # Also allow trackable to be null
      t.timestamps
    end
  end
end