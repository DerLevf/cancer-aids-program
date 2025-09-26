# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

    private

  # HILFSMETHODE: Prüft, ob der aktuelle Benutzer die angegebene Rolle im Projekt hat.
  # Dies ist notwendig, da die Rolle an die GroupMembership gebunden ist, nicht an den User.
  def user_is_role?(role_name)
    # Stellt sicher, dass der Benutzer existiert, das Projekt existiert (record) und dann
    # prüft die group_memberships des Projekts nach dem Benutzer mit der Rolle.
    user.present? && record.group_memberships.exists?(user: user, role: role_name)
  end

  protected

    def user_is_role?(role_name)
    user.present? && record.group_memberships.exists?(user: user, role: role_name)
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
