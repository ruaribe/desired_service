FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "TEST_NAME#{n}" }
    sequence(:email) { |n| "TEST#{n}@example.com"}
    sequence(:sex) { |n| n % 3 }
    sequence(:birthday) { Date.new(1995, 9, 24) }
    factory :ruaribe do
      sequence(:name) { 'Ruaribe' }
      sequence(:email) { 'ruaribe@example.com' }
    end
    factory :valid_user_params do
      sequence(:name) { 'foobar' }
      sequence(:email) { 'foobar@example.com' }
      sequence(:sex) {1}
      sequence(:birthday) { Date.new(2001, 7, 24) }
    end
    factory :invalid_user_params do
      sequence(:name) {nil}
      sequence(:email) {nil}
      sequence(:sex) {nil}
      sequence(:birthday) {nil}
    end
  end
end
