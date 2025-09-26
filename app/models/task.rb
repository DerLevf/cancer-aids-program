class Task < ApplicationRecord
  # belongs_to :assigned_to, class_name: "User"
  belongs_to :debt_project
enum :status, { in_progress: 0, completed: 1, overdue: 2 }

    belongs_to :assigned_user,
             class_name: "User",
             foreign_key: "assigned_to_id",
             optional: true
end
