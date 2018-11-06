class InventoryItemsController < ApplicationController
  def update
    # TODO: Should handle changing inventory, enabling, disabling, or changing markup.

    render file: 'errors/not_found', status: 404 unless current_user

    @merchant = User.find(params[:merchant_id])
    item_id = :item_id
    @inv_item = InventoryItem.find_by(merchant: @merchant, item_id: params[:item_id])

    render file: 'errors/not_found', status: 404 unless current_admin? || current_user == @merchant

    if request.fullpath.split('/')[-1] == 'disable'
      flash[:success] = "Item #{@inv_item.item.id} is now disabled in your store."
      @inv_item.active = false
      @inv_item.save
      redirect_to current_admin? ? merchant_items_path(@merchant) : dashboard_inventory_items_path
    elsif request.fullpath.split('/')[-1] == 'enable'
      flash[:success] = "Item #{@inv_item.item.id} is now enabled in your store."
      @inv_item.active = true
      @inv_item.save
      redirect_to current_admin? ? merchant_items_path(@merchant) : dashboard_inventory_items_path
    end
  end
end
