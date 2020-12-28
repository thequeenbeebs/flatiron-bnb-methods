class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :host_cannot_stay_at_own_listing
  validate :checkin_and_checkout
  validate :availability

  def array_of_dates
    arr = [checkin]
    n = checkin
    until n == checkout
      n += 1
      arr.push(n)
    end
    arr
  end

  def host_cannot_stay_at_own_listing
    if self.listing.host_id == self.guest_id
      errors.add(:guest_id, "cannot stay at your own listing")
    end
  end

  def checkin_and_checkout
    if self.checkin && self.checkout
      if self.checkin == self.checkout
        errors.add(:checkout, "cannot be same day as checkin")
      elsif self.checkin > self.checkout
        errors.add(:checkout, "must be after checkin")
      end
    end
  end

  def availability
    self.listing.reservations.each do |reservation|
      if reservation.array_of_dates.include?(self.checkin) || reservation.array_of_dates.include?(self.checkout)
        errors.add(:checkin, "conflicts with other reservation")
      end
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

end
