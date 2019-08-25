module RequestSpecSupport
  def log_in_as(login_user, remember_me = 0)
    post login_path, params: { session: { email: login_user.email,
                                          password: login_user.password,
                                          remember_me: remember_me } }
  end

  RSpec.configure do |config|
    config.include RequestSpecSupport
  end
end
