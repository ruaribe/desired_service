require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
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
  
        fill_in 'user_name', with: 'Ruaribe'
        fill_in 'user_email', with: 'ruaribe@example.com'
        select '男', from: 'user_sex'
        select '1994', from: 'user_birthday_1i'
        select '9', from: 'user_birthday_2i'
        select '22', from: 'user_birthday_3i'
  
        click_on 'Create User'
  
        expect(current_path).to eq "/users/#{User.last.id}"
        expect(page).to have_css('div.notice')
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
    before do
      @user = create(:ruaribe)
    end
  
    context '有効なパラメータな場合' do
      it 'ユーザー情報が更新され、詳細ページへ移動する' do
        visit "/users/#{@user.id}/edit"
  
        expect(page).to have_field 'user_name', with: 'Ruaribe'
        expect(page).to have_field 'user_email', with: 'ruaribe@example.com'
        expect(page).to have_select 'user_sex', selected: '男'
        expect(page).to have_select 'user_birthday_1i', selected: '1995'
        expect(page).to have_select 'user_birthday_2i', selected: '9'
        expect(page).to have_select 'user_birthday_3i', selected: '24'
  
        fill_in 'user_name', with: 'lily'
        fill_in 'user_email', with: 'lily@exam.jp'
        select '女', from: 'user_sex'
        select '2004', from: 'user_birthday_1i'
        select '12', from: 'user_birthday_2i'
        select '28', from: 'user_birthday_3i'
  
        click_on 'Update User'
  
        expect(current_path).to eq "/users/#{@user.id}"
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
        visit "/users/#{@user.id}/edit"
  
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
    before do
      @user = create(:ruaribe)
    end

    it 'ユーザーが削除され、一覧のページへ移動する' do
      visit '/users'
      expect(page).to have_content @user.name
      click_on '削除'

      expect(current_path).to eq '/users'
      expect(page).to have_no_content @user.name
    end
  end
end
