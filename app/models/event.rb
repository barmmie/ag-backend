class Event < ApplicationRecord
  include Store::Attributes

  has_many :tickets, dependent: :destroy

  validates :title, :artist, presence: true

  store_attributes :overrides do
    attribute :send_order_email, :boolean, default: true
    attribute :show_tickets_left, :boolean, default: false
  end

  delegate :send_order_email, :send_order_email=,
           :show_tickets_left, :show_tickets_left=,
           to: :overrides
end
