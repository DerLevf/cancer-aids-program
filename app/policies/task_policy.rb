# app/policies/task_policy.rb
class TaskPolicy < ApplicationPolicy
  def create?
    user_is_schuldner?
  end

  def update?
    user_is_schuldner?
    !record.completed?
  end

  def destroy?
    user_is_schuldner?
  end

  def show?
    # Erlaubt, wenn:
    # 1. Der Benutzer Mitglied der Gruppe ist (Schuldner ODER Collector) ODER
    # 2. Der Benutzer der Aufgabe zugewiesen wurde (assigned_user).
    user_is_group_member? || user_is_assigned?
  end
  private

  def user_is_assigned?
    record.assigned_user == user
  end

    def user_is_group_member?
    record.debt_project.group_memberships.exists?(user: user)
    end

  def user_is_schuldner?
    membership = record.debt_project.group_memberships.find_by(user: user)
    membership&.role == "schuldner"
  end
end
