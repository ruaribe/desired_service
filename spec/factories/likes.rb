FactoryBot.define do
  factory :like do
    trait :with_dependents do
      user
      post
    end
  end
end
