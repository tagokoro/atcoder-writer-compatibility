class Writer < ApplicationRecord
  has_many :writer_contests
  has_many :contests, through: :writer_contests
end