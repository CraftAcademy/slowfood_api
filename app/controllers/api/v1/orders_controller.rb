class Api::V1::OrdersController < ApplicationController
  def create
    order = Order.create
    order.order_items.create(product_id: params[:product_id])
    render json: create_json_response(order)
  end

  def update
    order = Order.find(params[:id])
    if params[:activity]
      order.update_attribute(:finalized, true)
      render json: { message: 'Your order will be ready in 30 minutes!' }
    else
      product = Product.find(params[:product_id])
      order.order_items.create(product: product)
      render json: create_json_response(order)
    end
  end

  private

  def create_json_response(order)
    json = { order: OrderSerializer.new(order) }
    json.merge!(message: 'The product has been added to your order')
  end
end