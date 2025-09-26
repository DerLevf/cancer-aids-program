class DebtProjectPolicy < ApplicationPolicy 
  attr_reader :user, :record



  def index?
    user.present?
  end

  def new?
    user.present?
  end

  def create?
    new?
  end

  def edit?
    user_is_creator?
  end

  def update?
    edit?
  end


  def show?
    # Benutzer darf das Projekt sehen, wenn er Mitglied ist
    record.users.include?(user)
  end

  def destroy?
    user_is_creator?
  end

  def show_completed_tasks?
    user_is_role?(:debt_collector)
    record.group_memberships.exists?(user: user)
  end

  private

  def user_is_creator?
    record.creator_id == user.id
  end
end
