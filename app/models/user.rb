class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  
  def host_reviews
    Review.all.select {|review| review.reservation.listing.host_id == self.id}
  end

  def hosts 
    User.all.select do |user| 
      user.reservations.select do |reservation|
        reservation.guest_id == self.id
      end
    end
  end

  def guests
    User.all.select do |user| 
      user.trips.select do |trip|
        trip.listing.host_id == self.id
      end
    end 
  end



end
