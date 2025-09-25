# db/migrate/XXXXXX_fix_task_assigned_to_foreign_key.rb

class FixTaskAssignedToForeignKey < ActiveRecord::Migration[7.1]
  def change
    # 1. Entferne den fehlerhaften Fremdschlüssel (der auf 'assigned_tos' zeigte)
    #    Dies ist notwendig, da der fehlerhafte Schlüssel in db/schema.rb steht
    #    und Rails ihn bei der Schema-Validierung vermutet.
    remove_foreign_key :tasks, column: :assigned_to_id

    # 2. Füge den korrekten Fremdschlüssel hinzu, der auf die 'users'-Tabelle zeigt
    add_foreign_key :tasks, :users, column: :assigned_to_id
  end
end
