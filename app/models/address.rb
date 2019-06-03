class Address < ApplicationRecord
  validates_presence_of :street, :city, :state, :zip

  belongs_to :user
  has_many :orders

  enum type: [:home, :work]
end
