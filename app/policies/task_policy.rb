# app/policies/task_policy.rb
class TaskPolicy < ApplicationPolicy
  def create?
    user_is_schuldner?
  end

  def update?
    user_is_schuldner?
  end

  def destroy?
    user_is_schuldner?
  end

  def show?
    user_is_schuldner?
  end

  private

  def user_is_schuldner?
    membership = record.debt_project.group_memberships.find_by(user: user)
    membership&.role == "schuldner"
  end
end
