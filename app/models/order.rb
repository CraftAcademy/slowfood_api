class Order < ApplicationRecord
  has_many :order_items

  def order_total
    order_items.joins(:product).sum("products.price")
  end
end
