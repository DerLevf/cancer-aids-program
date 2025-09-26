class ActivityLogsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @activity_logs = ActivityLog.order(created_at: :desc)
                                .includes(:user, :trackable, :debt_project)
                                .limit(50)

    authorize @activity_logs
  end

  def show
    @activity_log = ActivityLog.find(params[:id])
    authorize @activity_log
  end
end