class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  before_create :change_host_status
  after_destroy :remove_host_status

  def average_review_rating
    total = 0
    self.reviews.each do |review|
      total += review.rating
    end
    total.to_f / self.reviews.length.to_f
  end

  def change_host_status
    user = User.find(self.host_id)
    user.host = true
    user.save
  end

  def remove_host_status
    user = User.find(self.host_id)
    if user.listings.length == 0
      user.host = false
      user.save
    end
  end
  
end
