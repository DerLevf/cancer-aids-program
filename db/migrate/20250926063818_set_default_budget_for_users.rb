class SetDefaultBudgetForUsers < ActiveRecord::Migration[7.1]
  def change
    # Setzt den Standardwert auf 0.0 und stellt sicher, dass es nicht NULL ist
    change_column_default :users, :budget, from: nil, to: 0.0
    change_column_null :users, :budget, false, 0.0
  end
end
