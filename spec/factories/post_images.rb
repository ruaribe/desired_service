FactoryBot.define do
  factory :image, class: PostImage do
    post

    new_data { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'factories', 'image1.jpg'),'image/jpeg') }
    sequence(:alt_text) { |n| "テスト#{n}" }
    position { nil }
  end
end
