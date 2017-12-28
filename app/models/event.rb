class Event < ApplicationRecord
  include Store::Attributes

  has_many :tickets, dependent: :destroy do
    def lowest_total_price_for quantity
      Ticket.get_cheapest(records, quantity)
    end
  end  

  validates :title, :artist, presence: true

  store_attributes :overrides do
    attribute :send_order_email, :boolean, default: true
    attribute :show_tickets_left, :boolean, default: false
  end

  delegate :send_order_email, :send_order_email=,
           :show_tickets_left, :show_tickets_left=,
           to: :overrides
           
scope :email_enabled,   -> { where("overrides ->> 'send_order_email' = 'true' OR overrides ->> 'send_order_email' is NULL") }
scope :email_disabled,   ->{ where("overrides ->> 'send_order_email' = 'false'") }

 scope :tickets_left_enabled,   -> { where("overrides ->> 'show_tickets_left' = 'true' OR overrides ->> 'send_order_email' is NULL") }
 scope :tickets_left_disabled,   ->{ where("overrides ->> 'show_tickets_left' = 'false'") }
 
 scope :tickets_more_than,   ->(length){ joins(:tickets).group("events.id").having("count(tickets.id)> ?", length) }
 scope :ticket_count_exactly,   ->(length){ joins(:tickets).group("events.id").having("count(tickets.id) = ?", length) }
 
 scope :ticket_prices_less_than,   ->(price){ joins(:tickets).where("tickets.price < ?", price).distinct }
 
end
