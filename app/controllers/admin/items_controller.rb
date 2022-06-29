class Admin::ItemsController < ApplicationController
  def index
    @search = Item.ransack(params[:q])
    @items = @search.result.page(params[:page]).per(10)
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_item_path(@item)
    else
      redirect_to new_admin_item_path
    end
  end

  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_item_path(@item)
    else
      render :edit
    end 
  end

private
  # ストロングパラメータ
  def item_params
    params.require(:item).permit(:genre_id, :item_detail, :price_without_tax, :is_sale_status, :item_image, :name)
  end

end