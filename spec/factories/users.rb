FactoryBot.define do
  factory :user do

    trait :sample do
      sequence(:name) { |n| "sample_user#{n}" }
      sequence(:email) { |n| "sample#{n}@example.com" }
      sequence(:sex) { |n| n % 3 }
      sequence(:birthday) { Date.new(1995, 9, 24) }
      password { 'password' }
      password_confirmation { 'password' }
    end

    factory :testuser do
      name { 'TestUser' }
      email { 'testuser@example.com' }
      sex { 1 }
      birthday { '1994-09-22' }
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
  end
end
