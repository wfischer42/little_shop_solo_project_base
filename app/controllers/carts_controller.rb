class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    @inventory_items = InventoryItem.where(id: @cart.contents.keys)
  end

  def update
    inv_item = InventoryItem.find(params[:inventory_item_id])
    if params[:quantity] == 'more'
      if @cart.count_of(inv_item.id)+1 <= inv_item.inventory
        @cart.add_item(inv_item.id)
        flash[:success] = "Added another #{inv_item.item.name} to your cart"
      else
        flash[:warning] = "Cannot add another #{inv_item.item.name} to your cart, merchant doesn't have enough inventory"
      end
    elsif params[:quantity] == 'less'
      @cart.remove_item(inv_item.id)
      flash[:success] = "Removed #{inv_item.item.name} from your cart"
    elsif params[:quantity] == 'none'
      @cart.remove_all_item(inv_item.id)
      flash[:success] = "Removed entire quantity of #{inv_item.item.name} from your cart"
    end
    session[:cart] = @cart.contents
    redirect_back(fallback_location: items_path)
  end

  def empty
    session[:cart] = nil
    @cart = Cart.new({})
    redirect_to carts_path
  end
end
