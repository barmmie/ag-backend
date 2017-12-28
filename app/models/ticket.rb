class Ticket < ApplicationRecord
  belongs_to :event
  serialize :splits, Array

  validates :quantity, :price, :source, :event, presence: true
  
  def satisfies_split_vector(quantity)
    splits.any? { |split| quantity % split == 0 }
  end
  
  def max_split_buyable(amount)
    splits = []
    remaining_amount = amount
    while remaining_amount != 0
      split = get_highest_split(remaining_amount)
      splits << split
      remaining_amount = remaining_amount - split
    end
   ( splits.count > 0) ? splits.max : 0 
  end
  
  def get_highest_split(amount)
    
    available_splits = splits.sort.reverse
    index = 0
    split = available_splits[index]
    until amount >= split
       index = index + 1
       split = available_splits[index]
    end
    
    split
  end
  
  def self.get_cheapest (tickets, quantity)
    cheapest = nil
    tickets.each do |ticket|
      puts quantity
      max_buyable = ticket.max_split_buyable(quantity)
      
      quantity_bought = quantity - max_buyable
      
      cost = ticket.price * quantity_bought
      
      quantity_left = quantity - quantity_bought
      
      if quantity_left > 0
        cost = cost + get_cheapest(tickets, quantity_left)
      end
      if ( cheapest.nil? or cheapest > cost)
        cheapest = cost
      end
    end
    
    cheapest
  end
end
