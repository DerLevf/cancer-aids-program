class ActivityLogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def index?
    user.present?
  end

  def show?
    user.present?
  end
end