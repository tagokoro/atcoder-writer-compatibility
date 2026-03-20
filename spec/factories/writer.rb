FactoryBot.define do
  factory :writer do
    sequence(:username) { |n| "writer_#{n}"}
  end
end