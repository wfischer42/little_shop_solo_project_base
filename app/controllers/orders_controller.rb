class OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  # private
  #   def order_params
  #     params.require(:order).permit(:user_id, :status)
  #   end
end
