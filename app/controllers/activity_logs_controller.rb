class ActivityLogsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # 1. Daten abrufen und vorab laden (für Effizienz)
    @activity_logs = ActivityLog.order(created_at: :desc)
                                .includes(:user, :trackable, :debt_project)
                                # Wichtig: Für den Export limitieren wir NICHT.
                                # Das Limit(50) wird für den Export entfernt,
                                # da man meist alle Daten exportieren möchte.
                                

    # 2. Autorisierung (Pundit): Prüft, ob der Benutzer die Liste sehen darf.
    #    'index?' wird auf der Kollektion (@activity_logs) geprüft.
    authorize ActivityLog 

    respond_to do |format|
      format.html do
        # Das Limit wird nur für die HTML-Ansicht angewendet, um die Seite schnell zu halten.
        @activity_logs = @activity_logs.limit(50) 
      end
      
      format.csv do
        # Generiert die reinen CSV-Daten durch Aufruf der Model-Methode
        csv_data = @activity_logs.to_csv 
        
        # Sende die reinen Daten an den Browser, um den Download zu erzwingen
        send_data csv_data, 
                  filename: "activity-logs-#{Date.today}.csv",
                  type: 'text/csv; charset=utf-8', 
                  disposition: 'attachment' # Erzwingt den Download
      end
    end
  end

  def show
    @activity_log = ActivityLog.find(params[:id])
    authorize @activity_log
  end
end