class User < ApplicationRecord
  has_secure_password
  has_many :group_memberships, dependent: :destroy
  has_many :debt_projects, through: :group_memberships
  has_many :created_debt_projects, class_name: "DebtProject", foreign_key: "creator_id"
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigned_to_id"

  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { minimum: 3, maximum: 50 }

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false }

  def update_budget_by(amount_change)
    user_to_update = self.lock!

    safe_budget = user_to_update.budget || 0.0
    new_budget = safe_budget + amount_change

    user_to_update.update!(budget: new_budget)
  rescue => e
    Rails.logger.error "FEHLER: Budget-Update für User #{self.id} fehlgeschlagen: #{e.message}"
    raise
  end

  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?

  private

  def password_required?
    password_digest.blank? || !password.nil?
  end
end
