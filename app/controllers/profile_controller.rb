class ProfileController < ApplicationController
  def edit
    render file: 'errors/not_found', status: 404 unless current_user
    @user = current_user
  end

  def orders
    render file: 'errors/not_found', status: 404 unless current_user
    @user = current_user
    render :'orders/index'
  end
end