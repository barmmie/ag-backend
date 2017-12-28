class Ticket < ApplicationRecord
  belongs_to :event
  serialize :splits, Array

  validates :quantity, :price, :source, :event, presence: true
end
