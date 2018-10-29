class OrdersController < ApplicationController
  def index
    if request.fullpath == '/orders'
      if current_admin?
        @orders = Order.all
      else
        @orders = current_user.orders.where.not(status: :disabled)
      end
    elsif request.fullpath == "/dashboard/orders"
      @orders = current_user.merchant_orders(:pending)
    elsif params[:user_id] && request.fullpath == "/users/#{params[:user_id]}/orders"
      @user = User.find(params[:user_id])
      if @user == current_user
        @user.orders.where.not(status: :disabled)
      elsif current_admin?
        @orders = Order.all
      else
        render file: 'errors/not_found', status: 404
      end
    elsif params[:user_id] && request.fullpath == "/merchants/#{params[:user_id]}/orders"
      render file: 'errors/not_found', status: 404 unless current_admin?
      @merchant = User.find(params[:user_id])
      @orders = Order.all
    end
  end

  # private
  #   def order_params
  #     params.require(:order).permit(:user_id, :status)
  #   end
end
