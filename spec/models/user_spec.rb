require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validates' do
    it '有効なパラメータがそろっている場合' do
      user = build :testuser
      expect(user.valid?).to eq(true)
    end

    it 'nameが空だとNG' do
      user = build :testuser, name: ''
      expect(user.valid?).to eq(false)
    end

    it 'emailが空だとNG' do
      user = build :testuser, email: ''
      expect(user.valid?).to eq(false)
    end

    it 'emailの重複はNG' do
      create(:user, :sample, email: 'sample0@example.com')
      user = build :testuser, email: 'sample0@example.com'
      expect(user.valid?).to eq(false)
    end

    it '名前は50文字以下は有効' do
      user = build :testuser, name: 'a' * 50
      expect(user.valid?).to eq(true)
    end

    it '名前は51文字以上は無効' do
      user = build :testuser, name: 'a' * 51
      expect(user.valid?).to eq(false)
    end

    it 'メールアドレスは254文字以下は有効' do
      user = build :testuser, email: 'a' * 243 + '@example.com'
      expect(user.valid?).to eq(true)
    end

    it 'メールアドレスは255文字以上は無効' do
      user = build :testuser, email: 'a' * 244 + '@example.com'
      expect(user.valid?).to eq(false)
    end

    it '有効なメールアドレス' do
      user = build :testuser
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        user.email = valid_address
        expect(user.valid?).to eq(true)
      end
    end

    it '無効なメールアドレス' do
      user = build :testuser
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user.valid?).to eq(false)
      end
    end

    it 'メールアドレスは小文字へ変換して保存される' do
      user = build :testuser
      mixed_case_email = 'Foo@ExAMPle.CoM'
      user.email = mixed_case_email
      user.save
      expect(mixed_case_email.downcase).to eq user.reload.email
    end

    it 'パスワードは5文字以下は無効' do
      user = build :testuser, password: 'a' * 5, password_confirmation: 'a' * 5
      expect(user.valid?).to eq(false)
    end

    it 'パスワードは6文字以上は有効' do
      user = build :testuser, password: 'a' * 6, password_confirmation: 'a' * 6
      expect(user.valid?).to eq(true)
    end

    it 'パスワードは空白の場合は無効' do
      user = build :testuser, password: '', password_confirmation: ''
      expect(user).to_not be_valid
    end

    it '有効なパスワード' do
      user = build :testuser
      valid_passwords = %w[abcdef ABCDEF 123456 ______ 1aA_2bB_]
      valid_passwords.each do |valid_password|
        user.password = valid_password
        user.password_confirmation = valid_password
        expect(user.valid?).to eq(true)
      end
    end

    it '無効なパスワード' do
      user = build :testuser
      invalid_passwords = %w[a-cdef A.CDEF 1@3456 _\ ____ 1$A_2bB_]
      invalid_passwords.each do |invalid_password|
        user.password = invalid_password
        user.password_confirmation = invalid_password
        expect(user.valid?).to eq(false)
      end
    end

    it '性別のデフォルト値は0' do
      user = User.new
      expect(user.sex).to eq 0
    end
  end

  describe 'method' do
    let(:user) { build :testuser }

    it 'authenticated?メソッドはdigestがnilの時はfalseを返す' do
      expect(user.authenticated?('')).to eq(false)
    end
  end

  describe 'associated' do
    let(:user) { create(:testuser) }
    let(:post) { create(:post, :sample) }
    it 'ユーザーが削除されたら関連付けされている投稿も削除される' do
      user.posts.create!(content: 'test')
      expect do
        user.destroy
      end.to change(Post, :count).by(-1)
    end

    it 'ユーザーが削除されたら関連付けされているいいねも削除される' do
      user.likes.create!(post: post)
      expect do
        user.destroy
      end.to change(Like, :count).by(-1)
    end
  end
end
