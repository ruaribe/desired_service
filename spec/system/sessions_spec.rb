# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before do
    driven_by(:rack_test)
  end
  let(:user) { create(:testuser) }

  describe 'ログイン機能' do
    shared_examples 'ログイン画面のままで、エラーメッセージが表示されている' do
      it do
        expect(page).to have_content 'ログイン'
        expect(page).to have_no_content 'ログアウト'
        expect(page).to have_css '.alert'
      end
    end

    context '正しい情報を入力した場合' do
      it 'ログインして、マイページへ移動する' do
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        within '.col-md-6' do
          click_on 'ログイン'
        end

        expect(page).to have_no_content('ログイン')
        expect(page).to have_content('ログアウト')
        expect(current_path).to eq user_path(user)
      end
    end

    context 'emailが入力されていない場合' do
      before do
        visit login_path
        fill_in 'session_email', with: ''
        fill_in 'session_password', with: user.password
        within '.col-md-6' do
          click_on 'ログイン'
        end
      end

      it_behaves_like 'ログイン画面のままで、エラーメッセージが表示されている'
    end

    context 'passwordが入力されていない場合' do
      before do
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: ''
        within '.col-md-6' do
          click_on 'ログイン'
        end
      end

      it_behaves_like 'ログイン画面のままで、エラーメッセージが表示されている'
    end

    context 'emailとpasswordの組み合わせが間違っている場合' do
      before do
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: 'aaaaaaaa'
        within '.col-md-6' do
          click_on 'ログイン'
        end
      end

      it_behaves_like 'ログイン画面のままで、エラーメッセージが表示されている'
    end

    context 'emailとpasswordが入力されていない場合' do
      before do
        visit login_path
        fill_in 'session_email', with: ''
        fill_in 'session_password', with: ''
        within '.col-md-6' do
          click_on 'ログイン'
        end
      end

      it_behaves_like 'ログイン画面のままで、エラーメッセージが表示されている'
    end
  end

  describe 'ログアウト機能' do
    before { valid_login(user) }

    context 'ログアウトリンクをクリックした時' do
      it 'ログアウトし、トップページへ移動する' do
        expect(page).to have_no_content('ログイン')

        click_on 'ログアウト'
        expect(page).to have_no_link('ログアウト')
        expect(current_path).to eq root_path
      end
    end 
  end

  describe '簡単ログイン機能' do
    let!(:test_user) { create(:testuser) }

    it 'テストユーザーでログインしユーザー詳細ページへ移動する' do
      visit login_path
      within '.test_user_login' do
        click_on '簡単ログイン'
      end
      expect(page).to have_content test_user.name
      expect(current_path).to eq user_path(test_user)
    end
  end
end
