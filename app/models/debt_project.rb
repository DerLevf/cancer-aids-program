class DebtProject < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :group_memberships
  has_many :users, through: :group_memberships
  has_many :tasks, dependent: :destroy
end
