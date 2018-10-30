class Dashboard::OrdersController < ApplicationController
  def index
    @user = current_user
    @orders = @user.merchant_orders(:pending)
    render :'orders/index'
  end
end