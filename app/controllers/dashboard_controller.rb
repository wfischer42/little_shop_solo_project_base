class DashboardController < ApplicationController
  def show
    render file: 'errors/not_found', status: 404 unless current_user

    if current_user.merchant?
      @merchant = current_user
      render :'merchants/show'
    elsif current_admin?
      # not sure what we need here yet
    else
      render file: 'errors/not_found', status: 404
    end
  end
end