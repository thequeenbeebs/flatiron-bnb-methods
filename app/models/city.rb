class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    start_date = Date.parse date1
    end_date = Date.parse date2
    openings = []
    self.neighborhoods.each do |neighborhood|
      neighborhood.listings.each do |listing|
        openings << listing
      end
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

  def reservation_amt
    amount = 0
    self.listings.each do |listing|
      amount += listing.reservations.length
    end
    amount
  end

  def self.highest_ratio_res_to_listings
    City.all.max { |a, b| a.reservation_amt/a.listings.length <=> b.reservation_amt/b.listings.length}
  end

  def self.most_res
    City.all.max {|a, b |a.reservation_amt <=> b.reservation_amt}
  end

end

