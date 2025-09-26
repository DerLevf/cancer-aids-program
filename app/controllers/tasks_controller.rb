class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_debt_project
before_action :set_task, only: [ :show, :edit, :update, :destroy ]
  after_action :log_task_creation, only: [:create]
  after_action :log_task_update, only: [:update]
  after_action :log_task_deletion, only: [:destroy]

  def show
    # @task is set by the before_action :set_task
    authorize @task
    # Renders app/views/tasks/show.html.erb
  end

  def new
    @task = @debt_project.tasks.build
    authorize @task
  end

  def create
    @task = @debt_project.tasks.build(task_params)
    authorize @task
    if @task.save
      redirect_to debt_project_path(@debt_project), notice: "Aufgabe erstellt!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @task
  end

  def update
    # FIX: Policy-Prüfung hinzufügen. Pundit ruft TaskPolicy#update? auf.
    authorize @task

    if @task.update(task_params)
      redirect_to debt_project_path(@debt_project), notice: "Aufgabe aktualisiert!"
    else
      render :edit, status: :unprocessable_entity
    end
  rescue Pundit::NotAuthorizedError
    # Optionale Behandlung: Leite auf die Projektseite um mit einer spezifischen Fehlermeldung
    redirect_to debt_project_path(@debt_project), alert: "Fehler: Erledigte Aufgaben können nicht geändert werden."
  end

def completed_tasks
  authorize @debt_project, :show_completed_tasks? 
  @completed_tasks = @debt_project.tasks.where(status: 1).order(updated_at: :desc)
end

  def destroy
    authorize @task
    @task.destroy
    redirect_to debt_project_path(@debt_project), notice: "Aufgabe gelöscht!"
  end

  private

  def set_debt_project
    @debt_project = DebtProject.find(params[:debt_project_id])
  end
  def set_task
    @task = @debt_project.tasks.find_by(id: params[:id]) 
    
    unless @task
      redirect_to debt_project_path(@debt_project), alert: "Die angeforderte Aufgabe wurde nicht gefunden."
    end
  end

  private
  
  def task_params
    params.require(:task).permit(
      :title, 
      :description, 
      :assigned_to_id, 
      :deadline, 
      :status, 
      :amount 
    )
  end



  def log_task_creation
    ActivityLog.create!(
      user: current_user,
      debt_project: @debt_project,
      trackable: @task,
      action: "created_task",
      details: @task.attributes
    )
  end

  def log_task_update
    ActivityLog.create!(
      user: current_user,
      debt_project: @debt_project,
      trackable: @task,
      action: "updated_task",
      details: @task.saved_changes
    )
  end

  def log_task_deletion
    ActivityLog.create!(
      user: current_user,
      debt_project: @debt_project,
      trackable: @task,
      action: "deleted_task",
      details: @task.attributes
    )
  end


end
