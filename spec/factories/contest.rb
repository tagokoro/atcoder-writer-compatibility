FactoryBot.define do
  factory :contest do
    sequence(:contest_id) { |n| "contest_#{n}" }
  end
end
