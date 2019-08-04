User.create!(name: 'Ruaribe',
             email: 'ruaribe@testuser.com',
             sex: 1,
             birthday: '1994-09-22')

99.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  sex = n % 2
  birthday = '1999-01-01'
  User.create!(
    name: name,
    email: email,
    sex: sex,
    birthday: birthday
  )
end
