class DebtProjectsController < ApplicationController
  before_action :authenticate_user!
  
  # Callbacks für das Aktivitätsprotokoll hinzufügen
  after_action :log_project_creation, only: [:create]
  after_action :log_project_update, only: [:update]
  after_action :log_project_deletion, only: [:destroy]

  def index
    # Nur Projekte anzeigen, in denen der aktuelle Benutzer Mitglied ist
    @debt_projects = DebtProject
                      .joins(:group_memberships)
                      .where(group_memberships: { user_id: current_user.id })
                      .distinct
                      .order(:created_at)
  end

  # ... (andere Aktionen: new, edit, show, usw. bleiben unverändert) ...

def show
  @debt_project = DebtProject.find_by(id: params[:id])
  
  # Redirect or render a 404 if the project isn't found
  unless @debt_project
    redirect_to debt_projects_path, alert: "Die angeforderte Schuldengruppe wurde nicht gefunden."
    return # Stop execution here
  end

  authorize @debt_project
end

def edit
  @debt_project = DebtProject.find(params[:id])
  authorize @debt_project
  @other_users = User.where.not(id: current_user.id)
end

  def show_completed_tasks?
    # Erlaubt, wenn der Benutzer die Rolle 'debt_collector' in diesem Projekt hat
    user_is_role?(:debt_collector)
  end

def new
  # 1. Authorization checks the DebtProject class, not an instances
  authorize DebtProject 
  
  # 2. The instance variable MUST be created for the view
  @debt_project = DebtProject.new 
  
  # 3. Other necessary variables
  @other_users = User.where.not(id: current_user.id)
end

  def create
    @debt_project = DebtProject.new(debt_project_params)
    @debt_project.creator = current_user
    authorize @debt_project

    # Ersteller als Debtcollector hinzufügen
    @debt_project.group_memberships.build(user: current_user, role: :debt_collector)

    if @debt_project.save
      # HINWEIS: Das Logging passiert automatisch nach der Aktion durch den after_action-Callback.
      redirect_to debt_projects_path, notice: "Schuldengruppe erfolgreich erstellt!"
    else
      @other_users = User.where.not(id: current_user.id)
      render :new, status: :unprocessable_entity
    end
  end



  def update
    @debt_project = DebtProject.find(params[:id])
    authorize @debt_project

    if @debt_project.update(debt_project_params)
      # HINWEIS: Das Logging passiert automatisch nach der Aktion durch den after_action-Callback.
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
    # HINWEIS: Das Logging passiert automatisch nach der Aktion durch den after_action-Callback.
    redirect_to debt_projects_path, notice: "Schuldengruppe erfolgreich gelöscht!"
  end
  
  # ... (andere Aktionen und private Methoden bleiben unverändert) ...

  private


def debt_project_params
  params.require(:debt_project).permit(:name, :total_amount, :description, :deadline, schuldner_ids: [])
end

  # ... (debt_project_params, authenticate_user!, current_user bleiben unverändert) ...

  # NEUE LOGGING-METHODEN FÜR DEBT PROJECTS

  def log_project_creation
    # Das DebtProject ist jetzt das "trackable" Objekt
    ActivityLog.create!(
      user: current_user,
      debt_project: @debt_project,
      trackable: @debt_project,
      action: "created_debt_project",
      details: @debt_project.attributes
    )
  end

  def log_project_update
    # Nur protokollieren, wenn sich wirklich etwas geändert hat (saved_changes ist nicht leer)
    if @debt_project.saved_changes.any?
      ActivityLog.create!(
        user: current_user,
        debt_project: @debt_project,
        trackable: @debt_project,
        action: "updated_debt_project",
        details: @debt_project.saved_changes
      )
    end
  end

  def log_project_deletion
    deleted_project_details = @debt_project.attributes.slice("id", "name") 
    
    ActivityLog.create!(
      user: current_user,
      debt_project: nil, 
      trackable: nil,    
      action: "deleted_debt_project",
      details: deleted_project_details 
    )
  end

end