class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.date :deadline
      t.integer :status
      t.references :assigned_to, null: false, foreign_key: true
      t.references :debt_project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
