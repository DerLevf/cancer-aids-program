class AddDebtBalanceToUsers < ActiveRecord::Migration[7.1]
  def change
    # Setzt den Anfangsbetrag auf 0.00
    add_column :users, :debt_balance, :decimal, precision: 10, scale: 2, default: 0.0
  end
end