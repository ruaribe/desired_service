User.create!(name: 'TestUser',
             email: 'testuser@example.com',
             sex: 1,
             birthday: '1994-09-22',
             password: 'password',
             password_confirmation: 'password',
             admin: true)

99.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  sex = n % 3
  birthday = '1999-01-01'
  password = 'password'
  User.create!(
    name: name,
    email: email,
    sex: sex,
    birthday: birthday,
    password: password,
    password_confirmation: password
  )
end

filename = 'profile.png'
path = Rails.root.join(__dir__, filename)

user = User.find_by(name: 'TestUser')

File.open(path) do |f|
  user.profile_picture.attach(io: f, filename: filename)
end
