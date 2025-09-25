class DebtProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Alle Projekte, in denen der aktuelle Benutzer Mitglied ist
    @debt_projects = current_user.debt_projects
    # Kein @debt_project hier, damit form_for nicht nil wird
  end

  def new
    authorize DebtProject
    @debt_project = DebtProject.new
    # Alle anderen Benutzer für die Auswahl als Schuldner
    @other_users = User.where.not(id: current_user.id)
  end

  def create
    @debt_project = DebtProject.new(debt_project_params)
    @debt_project.creator = current_user
    authorize @debt_project

    # Ersteller als Debtcollector hinzufügen
    @debt_project.group_memberships.build(user: current_user, role: :debt_collector)

    if @debt_project.save
      # Ausgewählte Schuldner hinzufügen
      if params[:debt_project][:user_ids].present?
        params[:debt_project][:user_ids].each do |user_id|
          next if user_id.to_i == current_user.id
          @debt_project.group_memberships.create(user_id: user_id, role: :schuldner)
        end
      end
      redirect_to debt_projects_path, notice: "Schuldengruppe erfolgreich erstellt!"
    else
      @other_users = User.where.not(id: current_user.id)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def debt_project_params
    params.require(:debt_project).permit(:name, :total_amount, :description, :deadline, user_ids: [])
  end
end
