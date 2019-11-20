require 'rails_helper'

RSpec.describe "Passwords", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'パスワード変更機能' do
    let(:user) { create :testuser }
    let(:current_password) { user.password }
    let(:valid_password) { 'password2' }
    let(:invalid_password) { '      ' }

    before do
      valid_login(user)
    end

    it '有効な情報を入力してパスワードを変更する' do
      visit edit_password_path(user)

      fill_in 'user_current_password', with: current_password
      fill_in 'user_password', with: valid_password
      fill_in 'user_password_confirmation', with: valid_password

      click_on '更新する'

      expect(user.reload.authenticate(valid_password)).to eq user
      expect(user.reload.authenticate(current_password)).to eq false

      expect(current_path).to eq user_path(user)
      expect(page).to have_content "#{user.name}さんのページ"
      expect(page).to have_css('div.alert.alert-success')
    end
    it '無効な情報を入力してエラーメッセージを表示させる' do
      visit edit_password_path(user)

      fill_in 'user_current_password', with: current_password
      fill_in 'user_password', with: invalid_password
      fill_in 'user_password_confirmation', with: invalid_password

      click_on '更新する'

      expect(user.reload.authenticate(invalid_password)).to eq false
      expect(user.reload.authenticate(current_password)).to eq user

      expect(page).to have_field 'user_current_password'
      expect(page).to have_field 'user_password'
      expect(page).to have_field 'user_password_confirmation'
      expect(page).to have_css('div.alert.alert-danger')
    end
  end
end
