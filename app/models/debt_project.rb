class DebtProject < ApplicationRecord
  belongs_to :creator, class_name: "User"

  has_many :group_memberships, dependent: :destroy
  has_many :schuldner, -> { where(group_memberships: { role: :schuldner }) }, class_name: "User", source: :user, through: :group_memberships
  has_many :users, through: :group_memberships

  has_many :tasks, dependent: :destroy
end
