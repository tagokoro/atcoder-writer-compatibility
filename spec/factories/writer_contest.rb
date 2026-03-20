FactoryBot.define do
  factory :writer_contest do
    association :writer
    association :contest
  end
end
