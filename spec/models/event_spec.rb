require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'Querying events that send order emails' do
    before do
      @can_send_emails = FactoryGirl.create_list(:event, 5)
      @cannot_send_emails = FactoryGirl.create_list(:event, 5).each do |event|
        event.update(send_order_email: false)
      end
    end

    it 'succeeds in returning only events that send order emails' do
      enabled_events = Event.email_enabled

      3.times do
        expect(enabled_events).to include @can_send_emails.sample
      end
    end

    it 'succeeds in returning only events that don\'t send order emails' do
      disabled_events = Event.email_disabled

      3.times do
        expect(disabled_events).to include @cannot_send_emails.sample
      end
    end
  end

  describe 'Querying events that show tickets left' do
    before do
      @can_show_tickets = FactoryGirl.create_list(:event, 3)
      @cannot_show_tickets = FactoryGirl.create_list(:event, 5).each do |event|
        event.update(show_tickets_left: false)
      end
    end

    it 'succeeds in returning only events that show tickets left' do
      enabled_events = Event.tickets_left_enabled

      3.times do
        expect(enabled_events).to include @can_show_tickets.sample
      end
    end

    it 'succeeds in returning only events that don\'t show tickets left' do
      disabled_events = Event.tickets_left_disabled

      3.times do
        expect(disabled_events).to include @cannot_show_tickets.sample
      end
    end
  end

  describe 'Querying events with tickets' do
    before do
      FactoryGirl.create_list(:ticket, 2, price: 45, event: FactoryGirl.create(:event))
      FactoryGirl.create_list(:ticket, 5, price: 22, event: FactoryGirl.create(:event))
      FactoryGirl.create_list(:ticket, 3, price: 12, event: FactoryGirl.create(:event))
      FactoryGirl.create_list(:ticket, 1, price: 67, event: FactoryGirl.create(:event))
    end

    it 'succeeds in returning events with more than 2 tickets, successfully' do
      expect(Event.tickets_more_than(2).count).to eql 3
    end

    it 'succeeds in returning events with all ticket prices less than 20, successfully' do
      expect(Event.ticket_prices_less_than(20).count).to eql 1
    end

    it 'succeeds in returning events with exactly 5 tickets, successfully' do
      expect(Event.ticket_count_exactly(5).count).to eql 1
    end
  end
end
