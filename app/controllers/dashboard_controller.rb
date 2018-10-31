class DashboardController < ApplicationController
  def show
    render file: 'errors/not_found', status: 404 unless current_user

    if current_user.merchant?
      @merchant = current_user
      @total_items_sold = @merchant.total_items_sold
      @total_items_pcnt = 0
      if @total_items_sold && @merchant.total_inventory > 0
        @total_items_pcnt = @total_items_sold / @merchant.total_inventory
      end
      @top_3_shipping_states = @merchant.top_3_shipping_states
      @top_3_shipping_cities = @merchant.top_3_shipping_cities
      @most_active_buyer = @merchant.top_active_user
      @biggest_order = @merchant.biggest_order
      @top_buyers = @merchant.top_buyers(3)
      render :'merchants/show'
    elsif current_admin?
      # not sure what we need here yet
    else
      render file: 'errors/not_found', status: 404
    end
  end
end