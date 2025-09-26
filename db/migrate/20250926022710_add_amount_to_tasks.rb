class AddAmountToTasks < ActiveRecord::Migration[7.1]
  def change
    # Speichert den Betrag mit hoher Präzision (z.B. für Währungen)
    add_column :tasks, :amount, :decimal, precision: 10, scale: 2, default: 0.0
  end
end