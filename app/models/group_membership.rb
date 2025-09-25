class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :debt_project, optional: true
  enum :role, { schuldner: 0, debt_collector: 1 }
end
