class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  # private
  #   def item_params
  #     params.require(:item).permit(:user_id, :name, :description, :price, :inventory, :active)
  #   end
end
