FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:email) { |n| "TEST#{n}@example.com"}
    factory :ruaribe do
      sequence(:name) { 'Ruaribe' }
      sequence(:email) { 'ruaribe@example.com'}
    end
  end
end