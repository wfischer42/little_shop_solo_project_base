class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    if request.fullpath == '/profile'
      render file: 'errors/not_found', status: 404 unless current_user
      @user = current_user
    else # '/users/:id
      if current_admin?
        @user = User.find(params[:id])
      else
        render file: 'errors/not_found', status: 404
      end
    end
  end

  def new
    @user = User.new
  end

  def edit
    render file: 'errors/not_found', status: 404 if current_user.nil?
    if current_user
      @user = current_user
      if current_admin? && params[:id]
        @user = User.find(params[:id])
      elsif current_user && params[:id] && current_user.id != params[:id]
        render file: 'errors/not_found', status: 404
      end
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to profile_path, notice: 'Welcome to the site!'
    else
      render :new
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :city, :state, :zip)
    end
end
