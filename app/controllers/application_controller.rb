class ApplicationController < ActionController::Base
  include Pundit
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    redirect_to login_path, alert: "Du musst angemeldet sein." unless current_user
  end


  protected 

  def user_not_authorized
    # Define the custom message
    custom_message = "❌ Nu uhh. Du bist nicht berechtigt, diese Aktion auszuführen."

    # Use respond_to block for clear separation
    respond_to do |format|
      
      # 1. Handle Turbo Stream requests (AJAX/Hotwire)
      format.turbo_stream do
        # Use JSON.generate for safe string encoding in JavaScript
        alert_script = "<script>alert(#{JSON.generate(custom_message)});</script>"
        
        # We append a <script> tag to the body to force the alert
        render turbo_stream: turbo_stream.append('body', alert_script), 
               status: :forbidden # 403 Forbidden
      end
      
      # 2. Handle standard HTML requests (Full page load/redirect)
      format.html do
        # For a full HTML redirect, the standard flash mechanism should work
        flash[:alert] = custom_message
        redirect_back(fallback_location: root_path)
      end
      
      # Optional: Handle JSON/API requests if needed
      format.json { head :forbidden, status: :forbidden }
    end
  end
end
