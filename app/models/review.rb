class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :reservation_valid

  def reservation_valid
    if self.reservation != nil 
      if self.reservation.checkout > Date.today 
        errors.add(:reservation, "reservation is invalid")
      end
    end
  end

end
