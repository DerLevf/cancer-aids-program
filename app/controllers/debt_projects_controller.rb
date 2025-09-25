class DebtProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Zeige alle DebtProjects, in denen der aktuelle Benutzer Mitglied ist
    @debt_projects = current_user.debt_projects
  end

  def new
    # Autorisiert die Aktion mit Pundit
    authorize DebtProject
    @debt_project = DebtProject.new
    # Rufe alle Benutzer mit der Rolle "schuldner" ab
    @schuldner = User.where(role: "schuldner")
  end

  def create
    @debt_project = DebtProject.new(debt_project_params)
    @debt_project.creator = current_user
    # Autorisiert die Aktion mit Pundit
    authorize @debt_project

    # Fügt den Ersteller als Mitglied hinzu, mit der richtigen Rolle
    @debt_project.group_memberships.build(user: current_user, role: :debt_collector)

    if @debt_project.save
      # Fügt ausgewählte Schuldner als Mitglieder hinzu
      if params[:debt_project][:user_ids].present?
        params[:debt_project][:user_ids].each do |user_id|
          @debt_project.group_memberships.create(user_id: user_id, role: :schuldner)
        end
      end
      redirect_to debt_projects_index_path, notice: "Schuldengruppe erfolgreich erstellt!"
    else
      @schuldner = User.where(role: "schuldner")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "Du musst angemeldet sein, um diese Seite zu sehen."
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def debt_project_params
    params.require(:debt_project).permit(:name, :total_amount, :description, :deadline, user_ids: [])
  end
end
