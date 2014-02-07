class Resource < ActiveRecord::Base
  has_many :bookings
  validates :name, presence: true

  def filtered_bookings(from, to, status = nil)
    bs = bookings.between(from, to)
    #bs = bs.where(status: status) if status
    bs
  end

  def available?(from, to)
    filtered_bookings(from, to, 'pending').empty?
  end

end