require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'Calculating lowest possible price for tickets' do
    before do
      @event = FactoryGirl.create(:event)
      FactoryGirl.create(:ticket, price: 17, quantity: 3, splits: [1, 2], event: @event)
      FactoryGirl.create(:ticket, price: 15, quantity: 2, splits: [2], event: @event)
      FactoryGirl.create(:ticket, price: 19, quantity: 1, splits: [1], event: @event)
    end

    it 'calculates lowest possible price for 3 tickets' do
      expect(@event.tickets.lowest_total_price_for(3)).to eql(47)
    end

    it 'calculates lowest possible price for 1 ticket' do
      expect(@event.tickets.lowest_total_price_for(1)).to eql(17)
    end

    it 'calculates lowest possible price for 2 tickets' do
      expect(@event.tickets.lowest_total_price_for(2)).to eql(30)
    end

    it 'calculates lowest possible price for 5 tickets' do
      expect(@event.tickets.lowest_total_price_for(5)).to eql(83)
    end
  end
end
