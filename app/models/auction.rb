class Auction < ApplicationRecord
  belongs_to :user
  has_many :bids, -> {order(created_at: :DESC) }, dependent: :destroy
  has_many :bidders, through: :bids, source: :user

  validates :user_id, presence: true
  validates :title, presence: true, uniqueness: true
  validates :end_date, presence: true
  validate :valid_end_date?

  def current_price
    bids.empty? ? 0 : bids.first.price
  end

  def previous_bids
    bids.where.not(price: current_price)
  end

  private

  def valid_end_date?
    if end_date < Date.today
      errors.add(:due_date, 'cannot be before today\'s date.')
      return false
    end
    true
  end
end
