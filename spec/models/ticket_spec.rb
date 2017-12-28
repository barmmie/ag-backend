require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'Calculating lowest possible price for tickets' do
    before do
      @event = FactoryGirl.create(:event)
      @ticket1 = FactoryGirl.create(:ticket, price: 17, quantity: 3, splits: [1, 2, 3], event: @event)
      @ticket2 = FactoryGirl.create(:ticket, price: 15, quantity: 2, splits: [2], event: @event)
      @ticket3 = FactoryGirl.create(:ticket, price: 19, quantity: 1, splits: [1], event: @event)
    end

    it 'calculates lowest possible price for 3 tickets' do
      expect(@event.tickets.lowest_total_price_for(3).to_i).to eql(((@ticket2.price * 2) + (@ticket1.price)).to_i)
    end

   
  end
end
