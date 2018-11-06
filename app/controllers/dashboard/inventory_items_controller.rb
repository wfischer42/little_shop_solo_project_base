class Dashboard::InventoryItemsController < ApplicationController
  def index
    render file: 'errors/not_found', status: 404 unless current_user
    @inv_items = InventoryItem.where(merchant: current_user)
    @merchant_dashboard = (current_user.merchant?)
  end
end
