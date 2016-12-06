class Auction < ApplicationRecord
  belongs_to :user
  has_many :bids, -> {order(created_at: :DESC) }, dependent: :destroy
  has_many :bidders, through: :bids, source: :user

  validates :user_id, presence: true
  validates :title, presence: true, uniqueness: true
  validates :end_date, presence: true
  validates :reserve_price, presence: true
  validate :valid_end_date?

  include AASM
  aasm whiny_transitions: false do
    state :draft, initial: true
    state :published
    state :reserve_met
    state :won
    state :canceled
    state :reserve_not_met

    event :publish do
      transitions from: :draft, to: :published
    end

    event :meet_reserve do
      transitions from: :published, to: :reserve_met
    end

    event :sell do
      transitions from: :reserve_met, to: :won
    end

    event :cancel do
      transitions from: [:draft, :published, :won, :reserve_met], to: :canceled
    end

    event :do_not_sell do
      transitions from: :published, to: :reserve_not_met
    end
  end

  def current_price
    bids.empty? ? 0 : bids.first.price
  end

  def current_bidder
    return unless bids.present?
    bids.first.user
  end

  def current_bid
    return unless bids.present?
    bids.first
  end

  def previous_bids
    bids.where.not(price: current_price)
  end

  private

  def valid_end_date?
    return unless end_date.present? && DateTime.parse(end_date.to_s) < Date.today
    errors.add(:end_date, 'cannot be before today\'s date.')
  end

end
