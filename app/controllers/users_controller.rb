class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      role = params[:role]
      GroupMembership.create(user: @user, role: role)

      session[:user_id] = @user.id
      redirect_to debt_projects_index_path, notice: "Registrierung erfolgreich!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :budget)
  end
end
