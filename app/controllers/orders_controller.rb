class OrdersController < ApplicationController
  def index
    if request.fullpath == '/orders'
      if current_admin?
        @orders = Order.all
      else
        @orders = current_user.orders.where.not(status: :disabled)
      end
    elsif params[:user_id] && request.fullpath == "/users/#{params[:user_id]}/orders"
      @user = User.find(params[:user_id])
      if current_admin?
        @orders = Order.all
      # elsif @user == current_user
        # @orders = @user.orders.where.not(status: :disabled)
      # else
        # render file: 'errors/not_found', status: 404
      end
    elsif params[:merchant_id] && request.fullpath == "/merchants/#{params[:merchant_id]}/orders"
      render file: 'errors/not_found', status: 404 unless current_admin?
      @merchant = User.find(params[:merchant_id])
      @orders = @merchant.merchant_orders
    end
  end

  # private
  #   def order_params
  #     params.require(:order).permit(:user_id, :status)
  #   end
end
