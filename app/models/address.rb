class Address < ApplicationRecord
  validates_presence_of :street, :city, :state, :zip

    validates :nickname, presence: true, uniqueness: true

  belongs_to :user
  has_many :orders
end
