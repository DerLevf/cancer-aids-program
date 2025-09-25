class DebtProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Nur Projekte anzeigen, in denen der aktuelle Benutzer Mitglied ist
    @debt_projects = DebtProject
                      .joins(:group_memberships)
                      .where(group_memberships: { user_id: current_user.id })
                      .distinct
                      .order(:created_at)
  end



  def new
    authorize DebtProject
    @debt_project = DebtProject.new
    @other_users = User.where.not(id: current_user.id)
  end

  def create
    @debt_project = DebtProject.new(debt_project_params)
    @debt_project.creator = current_user
    authorize @debt_project

    # Ersteller als Debtcollector hinzufügen
    @debt_project.group_memberships.build(user: current_user, role: :debt_collector)

    if @debt_project.save
      redirect_to debt_projects_path, notice: "Schuldengruppe erfolgreich erstellt!"
    else
      @other_users = User.where.not(id: current_user.id)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @debt_project = DebtProject.find(params[:id])
    authorize @debt_project
    @other_users = User.where.not(id: current_user.id)
  end

  def update
    @debt_project = DebtProject.find(params[:id])
    authorize @debt_project

    if @debt_project.update(debt_project_params)
      redirect_to debt_projects_path, notice: "Schuldengruppe erfolgreich aktualisiert!"
    else
      @other_users = User.where.not(id: current_user.id)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @debt_project = DebtProject.find(params[:id])
    authorize @debt_project
    @debt_project.destroy
    redirect_to debt_projects_path, notice: "Schuldengruppe erfolgreich gelöscht!"
  end

  def show
    @debt_project = DebtProject.find(params[:id])
    authorize @debt_project
  end

  private

  def debt_project_params
    @debt_project_params ||= params.require(:debt_project).permit(:name, :total_amount, :description, :deadline, schuldner_ids: [])
  end

  def authenticate_user!
    redirect_to login_path, alert: "Du musst angemeldet sein." unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
