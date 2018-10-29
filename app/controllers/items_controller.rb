class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def update 
    render file: 'errors/not_found', status: 404 if current_user.nil?
    @merchant = User.find(params[:merchant_id])
    @item = Item.find(params[:item_id])
    render file: 'errors/not_found', status: 404 unless current_admin? || current_user == @merchant

    if request.fullpath.split('/')[-1] == 'disable'
      flash[:notice] = "Item #{@item.id} is now disabled"
      @item.active = false
      @item.save
      redirect_to current_admin? ? merchant_items_path(@merchant) : dashboard_items_path
    elsif request.fullpath.split('/')[-1] == 'enable'
      flash[:notice] = "Item #{@item.id} is now enabled"
      @item.active = true
      @item.save
      redirect_to current_admin? ? merchant_items_path(@merchant) : dashboard_items_path
    end
  end
  # private
  #   def item_params
  #     params.require(:item).permit(:user_id, :name, :description, :price, :inventory, :active)
  #   end
end
