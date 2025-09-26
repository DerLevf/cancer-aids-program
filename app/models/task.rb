class Task < ApplicationRecord
  # belongs_to :assigned_to, class_name: "User"
  belongs_to :debt_project
  enum :status, { in_progress: 0, completed: 1, overdue: 2 }

    belongs_to :assigned_user,
             class_name: "User",
             foreign_key: "assigned_to_id",
             optional: true
             
    # Validierung für den Betrag
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true


  # Führt die Logik nach dem Speichern aus, WENN der Status gewechselt hat und es einen Betrag gibt
  after_update :update_budgets_on_completion, if: :should_update_budgets?

  after_save :update_budgets_on_completion, if: :should_update_budgets? 
  
  private
    
  def should_update_budgets?
    # Muss bei Erstellung (nil -> completed) und Update (in_progress -> completed) TRUE sein
    saved_change_to_status? && completed? && amount.to_f > 0
  end

# ...

  def update_budgets_on_completion
    amount_float = amount.to_f
    if assigned_user.present?
      assigned_user.update_debt_balance(amount_float) 
    end
    debt_project.update_total_amount(amount_float) 
  end
end
