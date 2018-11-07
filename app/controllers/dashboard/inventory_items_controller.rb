class Dashboard::InventoryItemsController < ApplicationController
  def create
    InventoryItem.create(inventory_item_params.merge(active: false))
    redirect_to params[:path]
  end
  def index
    render file: 'errors/not_found', status: 404 unless current_user
    @inv_items = InventoryItem.where(merchant: current_user)
    @merchant_dashboard = (current_user.merchant?)
  end
  private
    def inventory_item_params
      params.require(:inventory_item).permit(:item_id, :user_id, :inventory, :markup)
    end
end
