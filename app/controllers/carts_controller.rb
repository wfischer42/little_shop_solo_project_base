class CartsController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    @items = Item.where(id: @cart.contents.keys)
  end

  def create
    item = Item.find(params[:item_id])

    @cart.add_item(item.id)
    session[:cart] = @cart.contents
    quantity = @cart.count_of(item.id)

    flash[:notice] = "Item has been added to your cart"
    redirect_back(fallback_location: items_path)
  end
end