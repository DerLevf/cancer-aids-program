class User < ApplicationRecord
  has_secure_password
  has_many :group_memberships, dependent: :destroy
  has_many :debt_projects, through: :group_memberships
  has_many :created_debt_projects, class_name: "DebtProject", foreign_key: "creator_id"
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assigned_to_id"
end
