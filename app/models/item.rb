class Item < ApplicationRecord
  has_many :order_details
  has_many :cart_items
  belongs_to :genre

  has_one_attached :item_image

  def with_tax_price
    (price_without_tax * 1.1).floor
  end
end
