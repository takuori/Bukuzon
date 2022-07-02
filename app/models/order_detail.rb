class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item
  
  enum making_status: { you_cannot_proceed: 0,
                        waiting_production: 1,
                        in_production: 2,
                        completed_production: 3,
  }
  
end
