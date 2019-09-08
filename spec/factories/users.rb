FactoryBot.define do
  factory :user do

    trait :sample do
      sequence(:name) { |n| "#{Faker::Name.name} #{n}" }
      sequence(:email) { |n| "sample#{n}@example.com" }
      sequence(:sex) { |n| n % 3 }
      sequence(:birthday) { Date.new(1995, 9, 24) }
      password { 'password' }
      password_confirmation { 'password' }
    end

    trait :invalid do
      name { '' }
      email { '' }
      sex { '' }
      birthday { '' }
      password { '' }
      password_confirmation { '' }
    end

    trait :man do
      sex { 1 }
    end

    trait :woman do
      sex { 2 }
    end

    trait :gender_not_set do
      sex { 0 }
    end

    factory :testuser do
      name { 'TestUser' }
      email { 'testuser@example.com' }
      sex { 1 }
      birthday { '1994-09-22' }
      password { 'password' }
      password_confirmation { 'password' }

      trait :admin do
        admin { true }
      end
    end
  end
end
