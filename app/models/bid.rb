class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction
  after_save :check_reserve

  validates :price, presence: true
  validate :valid_bid?

  private

  def valid_bid?
    return unless price.present? && price <= auction.current_price
    errors.add(:price, 'must be more than the current price.')
  end

  def check_reserve
    return unless auction.current_price >= auction.reserve_price
    auction.meet_reserve!
  end
end
