class WriterContest < ApplicationRecord
  belongs_to :writer
  belongs_to :contest

  validates :writer_id, uniqueness: { scope: :contest_id }
end
