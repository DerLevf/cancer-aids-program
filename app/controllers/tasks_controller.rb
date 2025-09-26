class TasksController < ApplicationController
  before_action :authenticate_user!

  # Füge hier die Methode completed_tasks ein

  def completed_tasks
    @debt_project = DebtProject.find(params[:id])

    # authorize @debt_project # Füge dies hinzu, wenn du eine Policy hast

    @completed_tasks = @debt_project.tasks.completed.order(updated_at: :desc)

  rescue ActiveRecord::RecordNotFound
    redirect_to debt_projects_path, alert: "Die angeforderte Schuldengruppe existiert nicht oder wurde nicht gefunden."
  end

  # ... (andere Task-Aktionen)
end
