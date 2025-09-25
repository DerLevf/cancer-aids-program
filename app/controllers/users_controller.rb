class UsersController < ApplicationController
  def new
    # Zeigt das Registrierungsformular an
    @user = User.new
  end

  def create
    # Erstellt einen neuen Benutzer aus den Formulardaten
    @user = User.new(user_params)
    if @user.save
      # Benutzer erfolgreich erstellt, Session starten
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Registrierung erfolgreich!"
    else
      # Fehler beim Speichern, Formular erneut anzeigen
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # Starke Parameter, um Massenzuweisungsangriffe zu verhindern
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
