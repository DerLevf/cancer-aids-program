class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_debt_project
  before_action :set_task, only: [ :edit, :update, :destroy ]

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
    authorize @task
    if @task.update(task_params)
      redirect_to debt_project_path(@debt_project), notice: "Aufgabe aktualisiert!"
    else
      render :edit, status: :unprocessable_entity
    end
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
    @task = @debt_project.tasks.find(params[:id])
  end

def task_params
  params.require(:task).permit(:title, :description, :status, :deadline,
                                :assigned_to_id)
end
end
