class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def self.highest_ratio_res_to_listings
    Neighborhood.all.max { |a, b| a.reservation_amt/(a.listings.length + 1) <=> b.reservation_amt/(b.listings.length + 1)}
  end

  def self.most_res
    Neighborhood.all.max {|a, b |a.reservation_amt <=> b.reservation_amt}
  end

  def reservation_amt
    amount = 0
    self.listings.each do |listing|
      amount += listing.reservations.length
    end
    amount
  end

  def neighborhood_openings(date1, date2)
    start_date = Date.parse date1
    end_date = Date.parse date2
    openings = []
    self.listings.each do |listing|
      openings << listing
    end
    openings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation.array_of_dates.include?(start_date) || reservation.array_of_dates.include?(end_date) 
          openings.delete(listing)
        end
      end
    end
    openings
  end

end
