class Address < ApplicationRecord
  validates_presence_of :street, :city, :state, :zip

    validates :nickname, presence: true

  belongs_to :user
  has_many :orders
end
