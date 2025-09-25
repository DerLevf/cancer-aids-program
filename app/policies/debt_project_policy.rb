class DebtProjectPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

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

  private

  def user_is_creator?
    record.creator_id == user.id
  end
end
