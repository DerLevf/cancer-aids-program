class Task < ApplicationRecord
  belongs_to :assigned_to, class_name: "User"
  belongs_to :debt_project
  enum :status, { in_progress: 0, completed: 1, overdue: 2 }
end
