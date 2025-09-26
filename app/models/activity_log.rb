class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :debt_project, optional: true
  belongs_to :trackable, polymorphic: true, optional: true
  serialize :details, coder: JSON
end