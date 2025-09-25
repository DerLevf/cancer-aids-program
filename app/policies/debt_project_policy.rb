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

  # Jeder angemeldete User darf neue Projekte erstellen
  def new?
    user.present?
  end

  def create?
    new?
  end
end
