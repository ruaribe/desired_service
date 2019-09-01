FactoryBot.define do
  factory :post do
    user
    sequence(:content) { |n| "test content#{n}" }
    trait :sample do
      association :user, :sample
    end
  end
end
