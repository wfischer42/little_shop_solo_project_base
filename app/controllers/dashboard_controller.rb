class DashboardController < ApplicationController
  def show
    if request.fullpath == '/dashboard'
      if current_user.merchant?
        @merchant = current_user
      elsif current_admin?
        # not sure what we need here yet
      else
        render file: 'errors/not_found', status: 404
      end
    elsif current_admin? && params[:user_id] && request.fullpath == merchant_path(params[:user_id])
      @merchant = User.find(params[:user_id])
      if @merchant.user?
        redirect_to user_path(@merchant)
      end
    else
      render file: 'errors/not_found', status: 404
    end
  end
end