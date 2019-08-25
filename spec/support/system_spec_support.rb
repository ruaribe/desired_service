module SystemSpecSupport
  def valid_login(login_user)
    visit login_path
    fill_in 'session_email', with: login_user.email
    fill_in 'session_password', with: login_user.password
    within '.col-md-6' do
      click_on 'ログイン'
    end
  end
end

RSpec.configure do |config|
  config.include SystemSpecSupport
end
