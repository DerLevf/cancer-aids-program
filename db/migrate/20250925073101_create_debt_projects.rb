class CreateDebtProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :debt_projects do |t|
      t.string :name
      t.decimal :total_amount
      t.text :description
      t.date :deadline
      t.references :creator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
