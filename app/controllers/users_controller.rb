class UsersController < ApplicationController
  before_action :authenticate_user!, only: [ :show, :edit, :update ]
  before_action :set_user, only: [ :show, :edit, :update ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save


      # role = params[:role] # schuldner oder debt_collector

      # default_project = DebtProject.first
      # GroupMembership.create!(
      #  user: @user,
      #  role: role,
      #  debt_project: default_project
      # ) if default_project

      session[:user_id] = @user.id
      redirect_to debt_projects_path, notice: "Registrierung erfolgreich!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @debt_projects = @user.debt_projects
    @created_projects = @user.created_debt_projects
    @assigned_tasks = @user.assigned_tasks
  end

  def edit
    # einfach Formular anzeigen
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "Profil erfolgreich aktualisiert!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    redirect_to root_path, alert: "Nicht erlaubt." unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :budget)
  end

  def authenticate_user!
    redirect_to login_path, alert: "Du musst angemeldet sein." unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
