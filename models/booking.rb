class Booking < ActiveRecord::Base
  belongs_to :resource
  belongs_to :user
  validates :resource, presence: true
end