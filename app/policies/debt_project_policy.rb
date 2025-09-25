class DebtProjectPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Jeder angemeldete User darf die Index-Seite sehen
  def index?
    user.present?
  end

  # Nur Debtcollector darf neue Projekte erstellen
  def new?
    user.group_memberships.exists?(role: :debt_collector)
  end

  def create?
    new?
  end
end
