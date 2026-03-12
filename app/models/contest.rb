class Contest < ApplicationRecord
  has_many :writer_contests
  has_many :writers, through: :writer_contests
end
