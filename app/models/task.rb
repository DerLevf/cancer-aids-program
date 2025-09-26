class Task < ApplicationRecord
  belongs_to :debt_project
  enum :status, { in_progress: 0, completed: 1, overdue: 2 }

  belongs_to :assigned_user,
             class_name: "User",
             foreign_key: "assigned_to_id",
             optional: true

  validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  after_update :execute_budget_transaction, if: :should_update_budgets?
  after_save :execute_budget_transaction, if: :should_update_budgets?

  private

  def should_update_budgets?
    saved_change_to_status? && completed? && amount.to_f > 0
  end

  def execute_budget_transaction
    amount_float = amount.to_f

    ApplicationRecord.transaction do
      if assigned_user.present?
        assigned_user.update_budget_by(-amount_float)
      end

      debt_collector = debt_project.creator
      if debt_collector.present?
        debt_collector.update_budget_by(amount_float)
      end

      debt_project.update_total_amount(amount_float)
    end
  rescue => e
    Rails.logger.error "FEHLER: Task-Abschluss Transaktion fehlgeschlagen: #{e.message}"
    raise
  end
end
