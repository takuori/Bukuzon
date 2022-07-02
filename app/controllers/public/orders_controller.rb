class Public::OrdersController < ApplicationController

  def index
    @orders = current_customer.orders.page(params[:page])
  end

  def new
    @order = Order.new
    @customer = current_customer
    @addresses = ShippingAddress.where(customer_id: current_customer.id)
    @cart_items = current_customer.cart_items
    @total_payment = @cart_items.sum{|cart_item|cart_item.item.price_without_tax * cart_item.quantity * 1.1 }
  end

  def create
    params[:order][:payment_method] = params[:order][:payment_method].to_i
    order = Order.new(order_params)
    order.save
    cart_items = current_customer.cart_items
    cart_items.each do |cart_item|
      order_detail = OrderDetail.new
      order_detail.order_id = order.id
      order_detail.item_id = cart_item.item.id
      order_detail.quantity = cart_item.quantity
      order_detail.making_status = 0
      order_detail.price_add_tax = (cart_item.item.price_without_tax * 1.1).floor
      order_detail.save
    end
    cart_items.destroy_all
    redirect_to orders_thanx_path
  end

  def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.shipping_cost = 800
    #合計金額を計算する処理
    @sum = 0
    @cart_items.each do |cart_item|
      @sum += cart_item.item.price_without_tax * cart_item.quantity
    end
    @order.total_payment = @sum * 1.1

    destination = params[:order][:select_address].to_i
    #ご自身の住所が選択されたとき
    if destination == 0
    @order.postcode = current_customer.postcode
    @order.address = current_customer.address
    @order.name = current_customer.last_name + current_customer.first_name
    #登録済みご住所が選択されたとき
    elsif destination == 1
      address = ShippingAddress.find(params[:order][:address_id])
      @order.postcode = address.postcode
      @order.address = address.address
      @order.name = address.name
    #新しいお届け先が選択されたとき
    elsif destination == 2
      @shipping_address = ShippingAddress.new
      @shipping_address.name = params[:order][:name]
      @shipping_address.address = params[:order][:address]
      @shipping_address.postcode = params[:order][:postcode]
      @shipping_address.customer_id = current_customer.id
      @shipping_address.save
    end
  end
  
  

  private

  def order_params
    params.require(:order).permit(:payment_method, :postcode, :address, :name, :shipping_cost, :total_payment, :order_status, :customer_id)
  end
end