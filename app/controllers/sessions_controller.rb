class SessionsController < ApplicationController
  helper_method :current_user

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      ActivityLog.create(user: user, action: "logged_in", details: { ip_address: request.remote_ip })
      redirect_to debt_projects_path, notice: "Anmeldung erfolgreich!"
    else
      flash.now[:alert] = "Ungültige E-Mail oder Passwort"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    ActivityLog.create(user: current_user, action: "logged_out")
    redirect_to root_path, notice: "Erfolgreich abgemeldet!"
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
