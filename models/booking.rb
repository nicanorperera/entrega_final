class Booking < ActiveRecord::Base
  belongs_to :resource
  belongs_to :user

  before_validation :set_status
  validates :resource, :start_time, :end_time, presence: true
  validates :status, inclusion: ['pending', 'approved']

  scope :between, -> (s, e) { where("start_time <= ? AND end_time >= ?", e, s).order(:start_time)}

  private

  def set_status
    @status = 'pending'
  end
end