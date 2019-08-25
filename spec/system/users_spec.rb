require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:login) { post login_url, params: { session: { email: login_user.email, password: login_user.password } } }
  let(:login_user) { create(:testuser) }
  let(:build_user) { build(:user, :sample) }

  before do
    driven_by(:rack_test)
  end

  describe 'ログイン機能とログアウト機能' do
    context '正しいメールアドレスとパスワードを入力した場合' do
      it 'ログインしてユーザー詳細画面へ、ログアウトリンクでログアウトし、トップページへ移動する。' do
        valid_login(login_user)

        expect(page).to have_no_content('ログイン')
        expect(current_path).to eq user_path(login_user)
        click_on 'ログアウト'
        expect(page).to have_no_link('ログアウト')
        expect(current_path).to eq root_path
      end
    end

    context 'メールアドレスとパスワードが一致しない場合' do
      it 'ログインできず、ログインページのままで、警告が表示されている' do
        visit login_path
        fill_in 'session_email', with: ''
        fill_in 'session_password', with: ''
        within '.col-md-6' do
          click_on 'ログイン'
        end
        expect(current_path).to eq login_path
        expect(page).to have_css '.alert'
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

  describe '新規ユーザー登録機能' do
    context '有効な情報を送信した時' do
      it '詳細ページへ移動し、ユーザーを作成したという通知が表示される。' do
        visit '/users/new'

        expect(page).to have_field 'user_name'
        expect(page).to have_field 'user_email'
        expect(page).to have_select('user_sex', selected: '未設定')
        expect(page).to have_select('user_birthday_1i', selected: Time.current.year.to_s)
        expect(page).to have_select('user_birthday_2i', selected: Time.current.month.to_s)
        expect(page).to have_select('user_birthday_3i', selected: Time.current.day.to_s)

        fill_in 'user_name', with: build_user.name
        fill_in 'user_email', with: build_user.email
        fill_in 'user_password', with: build_user.password
        fill_in 'user_password_confirmation', with: build_user.password
        select '男', from: 'user_sex'
        select '1994', from: 'user_birthday_1i'
        select '9', from: 'user_birthday_2i'
        select '22', from: 'user_birthday_3i'

        click_on 'Create User'

        expect(current_path).to eq user_path(User.last)
        expect(page).to have_css('div.notice')
        expect(page).to have_content(build_user.name)
        expect(page).to have_no_link('ログイン')
        expect(page).to have_link('ログアウト')
      end
    end

    context '無効な情報を送信した場合' do
      it '画面は移動せず、エラーメッセージが表示される' do
        visit '/users/new'
  
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        select '男', from: 'user_sex'
        select '1994', from: 'user_birthday_1i'
        select '9', from: 'user_birthday_2i'
        select '22', from: 'user_birthday_3i'
  
        click_on 'Create User'
  
        expect(page).to have_css('div#error_explanation')
  
        expect(page).to have_field 'user_name'
        expect(page).to have_field 'user_email'
        expect(page).to have_select('user_sex', selected: '男')
        expect(page).to have_select('user_birthday_1i', selected: '1994')
        expect(page).to have_select('user_birthday_2i', selected: '9')
        expect(page).to have_select('user_birthday_3i', selected: '22')
      end
    end
  end

  describe 'ユーザー情報更新機能' do
    before  { valid_login(login_user) } 

    context '有効なパラメータな場合' do
      it 'ユーザー情報が更新され、詳細ページへ移動する' do
        visit "/users/#{login_user.id}/edit"

        expect(page).to have_field 'user_name', with: login_user.name
        expect(page).to have_field 'user_email', with: login_user.email
        expect(page).to have_select 'user_sex', selected: '男'
        expect(page).to have_select 'user_birthday_1i', selected: '1994'
        expect(page).to have_select 'user_birthday_2i', selected: '9'
        expect(page).to have_select 'user_birthday_3i', selected: '22'

        fill_in 'user_name', with: 'lily'
        fill_in 'user_email', with: 'lily@exam.jp'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        select '女', from: 'user_sex'
        select '2004', from: 'user_birthday_1i'
        select '12', from: 'user_birthday_2i'
        select '28', from: 'user_birthday_3i'

        click_on 'Update User'

        expect(current_path).to eq "/users/#{login_user.id}"
        expect(page).to have_css('div.notice')
        expect(page).to have_content 'lily'
        expect(page).to have_content 'lily@exam.jp'
        expect(page).to have_content '女'
        expect(page).to have_content '2004'
        expect(page).to have_content '12'
        expect(page).to have_content '28'
      end
    end

    context '無効なパラメータな場合' do
      it 'ユーザー情報は更新されずに、編集ページが表示されてエラーメッセージが表示されている' do
        visit "/users/#{login_user.id}/edit"

        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        select '女', from: 'user_sex'
        select '2004', from: 'user_birthday_1i'
        select '12', from: 'user_birthday_2i'
        select '28', from: 'user_birthday_3i'

        click_on 'Update User'

        expect(page).to have_css('div#error_explanation')

        expect(page).to have_field 'user_name'
        expect(page).to have_field 'user_email'
        expect(page).to have_select('user_sex', selected: '女')
        expect(page).to have_select('user_birthday_1i', selected: '2004')
        expect(page).to have_select('user_birthday_2i', selected: '12')
        expect(page).to have_select('user_birthday_3i', selected: '28')
      end
    end
  end

  describe 'ユーザー削除機能' do
    let!(:user) { create :user, :sample }
    before do
      visit login_path
      fill_in 'session_email', with: login_user.email
      fill_in 'session_password', with: login_user.password
      within '.col-md-6' do
        click_on 'ログイン'
      end
    end

    it 'ユーザーが削除され、一覧のページへ移動する' do
      visit '/users'
      expect(page).to have_content user.name
      click_on '削除', match: :first

      expect(current_path).to eq '/users'
      expect(page).to have_no_content user.name
    end
  end
end
