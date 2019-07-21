require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:ruaribe)
  end

  describe 'valid' do
    it 'nameとemailどちらも値が設定されていれば、OK' do
      expect(@user.valid?).to eq(true)
    end

    it 'nameが空だとNG' do
      @user.name = ''
      expect(@user.valid?).to eq(false)
    end

    it 'emailが空だとNG' do
      @user.email = ''
      expect(@user.valid?).to eq(false)
    end

    it 'emailの重複はNG' do
      @other_user = create(:user)
      @user.email = 'TEST1@example.com'
      expect(@user.valid?).to eq(false)
    end

    it '名前は50文字まで'do
      @user.name = 'a' * 51
      expect(@user.valid?).to eq(false)
    end

    it 'メールアドレスは255文字まで' do
      @user.email = 'a' * 244 + '@example.com'
      expect(@user.valid?).to eq(false)
    end

    it '有効なメールアドレス' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                            first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user.valid?).to eq(true)
      end
    end

    it '無効なメールアドレス' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user.valid?).to eq(false)
      end
    end
  end
end
