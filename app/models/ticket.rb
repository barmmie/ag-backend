class Ticket < ApplicationRecord
  belongs_to :event
  serialize :splits, Array

  validates :quantity, :price, :source, :event, presence: true
  
  def max_split_buyable(amount)
    
    if quantity == amount
      return amount
    end
  
    sorted_splits = splits.sort_by {|v| -v} 
  
    available = 0
  
    min_quantity = [quantity, amount].min
  
    for split in sorted_splits do
      while available + split <= min_quantity
        available += split
      end
      if available == min_quantity
        break
      end
    end
  
    available
  end

  
  def self.get_cheapest (tickets, requested_quantity)
    total_bought = 0
    chosen_tickets = []
    tickets.sort_by {|ticket| ticket.price}.each do |ticket|
      if total_bought == requested_quantity
        break;
      end
      
      current_requested_quantity = requested_quantity - total_bought
        
      available_quantity = ticket.max_split_buyable(current_requested_quantity)
    
      if available_quantity.nil? || available_quantity == 0
        next
      end
      
      chosen_tickets.push({
        :id => ticket.id,
        :price => ticket.price,
        :cost => ticket.price * available_quantity,
        :quantity => available_quantity
      })

      ticket.quantity = ticket.quantity - available_quantity

      total_bought += available_quantity
    end
    
   cheapest = chosen_tickets.inject(0){|sum,ticket| sum + ticket[:cost] }
   cheapest
  end
end
