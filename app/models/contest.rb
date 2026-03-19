class Contest < ApplicationRecord
  has_many :writer_contests
  has_many :writers, through: :writer_contests

  validates :contest_id, uniqueness: { scope: :contest_type }

  def self.latest_id(type:)
    where(contest_type: type).maximum(:contest_id)
  end
end
