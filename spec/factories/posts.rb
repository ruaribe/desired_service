FactoryBot.define do
  factory :post do
    user
    sequence(:content) { |n| "content#{n} test" }
    trait :sample do
      association :user, :sample
    end
  end
end
