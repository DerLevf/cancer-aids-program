class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      role = params[:role] # schuldner oder debt_collector

      # Optional: Default-Projekt anlegen oder nil, wenn noch kein Projekt existiert
      default_project = DebtProject.first # z.B. erstes Projekt, oder nil
      GroupMembership.create!(
        user: @user,
        role: role,
        debt_project: default_project
      )

      session[:user_id] = @user.id
      redirect_to debt_projects_path, notice: "Registrierung erfolgreich!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :budget)
  end
end
