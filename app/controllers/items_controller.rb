class ItemsController < ApplicationController
  def index
    # if current_user && current_user.merchant? || current_admin?
    #   @items = Item.all
    # else
      @items = Item.where(active: true)
    # end
  end

  def new 
    @item = Item.new 
    @merchant = User.find(params[:merchant_id])
    @form_url = merchant_items_path
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit 
    render file: 'errors/not_found', status: 404 if current_user.nil?
    @merchant = User.find(params[:merchant_id])
    render file: 'errors/not_found', status: 404 unless current_admin? || current_user == @merchant
    @item = Item.find(params[:id])
    @form_url = merchant_item_path(@merchant, @item)
  end

  def create 
    render file: 'errors/not_found', status: 404 if current_user.nil?
    @merchant = User.find(params[:merchant_id])
    render file: 'errors/not_found', status: 404 unless current_admin? || current_user == @merchant

    @item = @merchant.items.create(item_params)
    if @item.save
      if @item.image.nil? || @item.image.empty?
        @item.image = 'placeholder.jpg'
        @item.save
      end
      flash[:notice] = "Item created"
      redirect_to current_admin? ? merchant_items_path(@merchant) : dashboard_items_path
    else
      @form_url = merchant_items_path
      render :new
    end
  end

  def update 
    render file: 'errors/not_found', status: 404 if current_user.nil?
    @merchant = User.find(params[:merchant_id])
    item_id = :item_id
    if params[:id]
      item_id = :id
    end
    @item = Item.find(params[item_id])
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
    else
      @item.update(item_params)
      if @item.save
        flash[:notice] = "Item updated"
        redirect_to current_admin? ? merchant_items_path(@merchant) : dashboard_items_path
      else
        @form_url = merchant_item_path(@merchant, @item)
        render :edit
      end
    end
  end


  private
    def item_params
      params.require(:item).permit(:user_id, :name, :description, :image, :price, :inventory)
    end
end
