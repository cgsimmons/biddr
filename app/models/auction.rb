class Auction < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :title, presence: true, uniqueness: true
  validates :end_date, presence: true
  validate :valid_end_date?

  private

  def valid_end_date?
    if end_date < Date.today
      errors.add(:due_date, 'cannot be before today\'s date.')
      return false
    end
    true
  end
end
