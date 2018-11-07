class ItemsController < ApplicationController
  def index
      if params[:merchant_id] && @merchant = User.find(params[:merchant_id])
        @items = Item.not_stocked_by(@merchant)
        @inv_item = InventoryItem.new()
        @path = unstocked_merchant_items_path
      else
        @items = Item.where(active: true)
      end

      @popular_items = Item.popular_items(5)
      @popular_merchants = User.popular_merchants(5)
      @fastest_merchants = User.fastest_merchants(3)
      @slowest_merchants = User.slowest_merchants(3)
  end

  def new
    @item = Item.new
    @form_url = items_path
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    render file: 'errors/not_found', status: 404 unless current_admin? || current_user.merchant?
    @item = Item.find(params[:id])
    @form_url = item_path(@item)
  end

  def create
    render file: 'errors/not_found', status: 404 unless current_admin? || current_user.merchant?

    @item = Item.create(item_params)
    if @item.save
      if @item.image.nil? || @item.image.empty?
        @item.image = 'https://picsum.photos/200/300/?image=0&blur=true'
        @item.save
      end
      flash[:success] = "Item created"
      redirect_to current_admin? ? items_path : item_path(@item)
    else
      @form_url = items_path
      render :new
    end
  end

  def update
    render file: 'errors/not_found', status: 404 if current_user.nil?
    item_id = :item_id
    if params[:id]
      item_id = :id
    end
    @item = Item.find(params[item_id])
    render file: 'errors/not_found', status: 404 unless current_admin? || current_user.merchant?

    if request.fullpath.split('/')[-1] == 'disable'
      flash[:success] = "Item #{@item.id} is now disabled"
      @item.active = false
      @item.save
      redirect_to current_admin? ? items_path : dashboard_inventory_items_path
    elsif request.fullpath.split('/')[-1] == 'enable'
      flash[:success] = "Item #{@item.id} is now enabled"
      @item.active = true
      @item.save
      redirect_to current_admin? ? items_path : dashboard_inventory_items_path
    else
      @item.update(item_params)
      if @item.save
        flash[:success] = "Item updated"
        redirect_to current_admin? ? items_path : dashboard_inventory_items_path
      else
        @form_url = item_path(@item)
        render :edit
      end
    end
  end


  private
    def item_params
      params.require(:item).permit(:user_id, :name, :description, :image, :price, :inventory)
    end
end
