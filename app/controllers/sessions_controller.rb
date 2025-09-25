class SessionsController < ApplicationController
  def new
    # Initialisiert die @user-Variable, damit das Registrierungsformular in der gleichen View rendert
    @user = User.new
  end

  def create
    # Sucht den Benutzer anhand der E-Mail-Adresse und authentifiziert das Passwort
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      # Anmeldedaten sind korrekt, Session starten
      session[:user_id] = user.id
      redirect_to root_path, notice: "Anmeldung erfolgreich!"
    else
      # Anmeldedaten sind falsch, Fehlermeldung anzeigen
      flash.now[:alert] = "Ungültige E-Mail oder Passwort."
      render :new, status: :unauthorized
    end
  end

  def destroy
    # Beendet die Session des Benutzers
    session[:user_id] = nil
    redirect_to root_path, notice: "Abmeldung erfolgreich!"
  end
end
