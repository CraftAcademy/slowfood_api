class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total, :products

  def products
    object.order_items.group_by(&:product_id).map do |_key, value|
      product = value.first.product
      { amount: value.size, name: product.name, total: (value.size * product.price)  }
    end
  end

  def total
    object.order_items.joins(:product).sum('products.price')
  end
end
