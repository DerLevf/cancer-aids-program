class FixDebtProjectsCreatorForeignKey < ActiveRecord::Migration[8.0]
  def change
    # Falschen Foreign Key entfernen, falls vorhanden
    remove_foreign_key :debt_projects, column: :creator_id rescue nil

    # Richtigen Foreign Key hinzufügen
    add_foreign_key :debt_projects, :users, column: :creator_id
  end
end
