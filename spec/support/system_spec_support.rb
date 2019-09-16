module SystemSpecSupport
  def valid_login(login_user)
    visit login_path
    fill_in 'session_email', with: login_user.email
    fill_in 'session_password', with: login_user.password
    within '.login' do
      click_on 'ログイン'
    end
  end

  def show_gender(db_gender)
    genders = %w[未設定 男 女]
    genders[db_gender]
  end

  def show_birthday(birthday)
    birthday&.strftime('%Y年%m月%d日')
  end
end

RSpec.configure do |config|
  config.include SystemSpecSupport
end
