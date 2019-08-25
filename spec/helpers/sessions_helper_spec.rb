require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'current_user' do
    before do
      @user = create(:testuser)
      remember(@user)
    end
    it 'sessionがnilの時、cookiesで認証して正しいユーザーを返す。' do
      expect(current_user).to eq(@user)
      expect(logged_in?).to eq(true)
    end

    it 'remember_digestがremember_tokenに対応していないときはnilを返す' do
      @user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to eq(nil)
    end
  end
end
