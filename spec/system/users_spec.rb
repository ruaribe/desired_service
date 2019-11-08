# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:login) { post login_url, params: { session: { email: login_user.email, password: login_user.password } } }
  let(:login_user) { create(:testuser) }
  let(:build_user) { build(:user, :sample) }
  let(:user) { create(:testuser) }
  let(:admin) { create(:testuser, :admin) }

  before do
    driven_by(:rack_test)
  end

  describe 'ユーザー一覧表示' do
    let!(:otherusers) { create_list(:user, 15, :sample) }

    shared_examples 'ユーザー名がリンクになっている一覧が表示される。' do
      it do
        otherusers.each do |user|
          expect(page).to have_link user.name, href: user_path(user)
        end
      end
    end

    shared_examples 'リンクをクリックしたらそのユーザーの詳細ページへ移動する。' do
      it do
        click_link otherusers[0].name
        expect(current_path).to eq user_path(otherusers[0])
      end
    end

    context 'ログインしていない場合' do
      before { visit users_path }

      it_behaves_like 'ユーザー名がリンクになっている一覧が表示される。'
      it_behaves_like 'リンクをクリックしたらそのユーザーの詳細ページへ移動する。'
    end

    context '一般ユーザーでログインしている場合' do
      before do
        valid_login(user)
        visit users_path
      end

      it_behaves_like 'ユーザー名がリンクになっている一覧が表示される。'
      it_behaves_like 'リンクをクリックしたらそのユーザーの詳細ページへ移動する。'

      
    end

    context '管理者ユーザーでログインしている場合' do
      before do
        valid_login(admin)
        visit users_path
      end

      it_behaves_like 'ユーザー名がリンクになっている一覧が表示される。'
      it_behaves_like 'リンクをクリックしたらそのユーザーの詳細ページへ移動する。'
    end

    describe 'ページネーション機能' do
      before do
        create_list(:user, 21, :sample, created_at: '1994-09-22')
      end
      it '2ページ目の投稿一覧を開く' do
        valid_login(login_user)

        click_link '会員一覧'

        expect(page).to have_css('.pagination', count: 2)
        expect(page).to have_no_css 'span.prev'

        User.order(created_at: :desc).page(1).per(20) do |user|
          expect(page).to have_link user.name
        end

        find('span.next', match: :first).click_link

        User.order(created_at: :desc).page(2).per(20) do |user|
          expect(page).to have_link user.name
        end

        expect(page).to have_no_css 'span.next'
        expect(page).to have_css 'span.prev'
      end
    end
  end

  describe '新規ユーザー登録機能' do
    before { visit new_user_path }

    context '有効な情報を送信した時' do
      it '詳細ページへ移動し、ユーザーを作成したという通知が表示される。' do
        attach_file 'user_new_profile_picture', "#{Rails.root}/spec/factories/profile1.png"
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
        expect(page).to have_css('div.alert')
        expect(page).to have_content(build_user.name)
        expect(page).to have_css 'img.profile_picture'
        expect(page).to have_no_link('ログイン')
        expect(page).to have_link('ログアウト')
      end
    end

    context '無効な情報を送信した場合' do
      it '画面は移動せず、エラーメッセージが表示される' do
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

  describe 'ユーザー詳細表示機能' do
    shared_examples 'ユーザー情報が表示される' do
      it do
        expect(page).to have_content show_user.name
        expect(page).to have_content show_user.email
        expect(page).to have_content show_gender(show_user.sex)
        expect(page).to have_content show_birthday(show_user.birthday)
      end
    end

    let!(:show_user) { create(:user, :sample) }
    context 'ログインしていない場合' do
      before { visit user_path(show_user) }
      it_behaves_like 'ユーザー情報が表示される'
    end

    context '一般ユーザーでログインしている場合' do
      before do
        valid_login(user)
        visit user_path(show_user)
      end

      it_behaves_like 'ユーザー情報が表示される'
    end

    context '管理者ユーザーでログインしている場合' do
      before do
        valid_login(admin)
        visit user_path(show_user)
      end

      it_behaves_like 'ユーザー情報が表示される'
    end
  end

  describe 'ユーザー情報更新機能' do
    before do
      valid_login(user)
    end

    context '有効なパラメータな場合' do
      it 'ユーザー情報が更新され、詳細ページへ移動する' do
        visit edit_user_path(user)

        expect(page).to have_field 'user_name', with: user.name
        expect(page).to have_field 'user_email', with: user.email
        expect(page).to have_select 'user_sex', selected: '男'
        expect(page).to have_select 'user_birthday_1i', selected: '1994'
        expect(page).to have_select 'user_birthday_2i', selected: '9'
        expect(page).to have_select 'user_birthday_3i', selected: '22'

        fill_in 'user_name', with: 'lily'
        fill_in 'user_email', with: 'lily@exam.jp'
        select '女', from: 'user_sex'
        select '2004', from: 'user_birthday_1i'
        select '12', from: 'user_birthday_2i'
        select '28', from: 'user_birthday_3i'

        click_on 'Update User'

        expect(current_path).to eq user_path(user)
        expect(page).to have_css('div.alert')
        expect(page).to have_no_css 'img.profile_picture'
        expect(page).to have_content 'lily'
        expect(page).to have_content 'lily@exam.jp'
        expect(page).to have_content '女'
        expect(page).to have_content '2004年12月28日'
      end
    end

    context '無効なパラメータな場合' do
      it 'ユーザー情報は更新されずに、編集ページが表示されてエラーメッセージが表示されている' do
        visit edit_user_path(user)

        fill_in 'user_name', with: ''
        fill_in 'user_email', with: ''
        select '女', from: 'user_sex'
        select '2004', from: 'user_birthday_1i'
        select '12', from: 'user_birthday_2i'
        select '28', from: 'user_birthday_3i'

        click_on 'Update User'

        expect(page).to have_css('div#error_explanation')

        expect(page).to have_content 'マイアカウントの編集'

        visit user_path(user)

        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_content '男'
        expect(page).to have_content '1994年09月22日'
      end
    end

    describe 'プロフィール画像の変更' do
      context '画像を設定している場合' do
        before do
          user.profile_picture.attach(io: File.open('spec/factories/profile1.png'),
          filename: 'profile1.png', content_type: 'application/png')
        end
        it '画像を変更できる' do
          visit edit_user_path(user)

          expect(page).to have_css "img[src$='profile1.png']"

          attach_file 'user_new_profile_picture', "#{Rails.root}/spec/factories/profile2.png"

          click_on 'Update User'

          expect(current_path).to eq user_path(user)
          expect(page).to have_css('div.alert')
          expect(page).to have_css 'img.profile_picture'
          expect(page).to have_css "img[src$='profile2.png']"
        end

        it '画像を削除できる' do
          visit edit_user_path(user)

          check('user_remove_profile_picture')

          click_on 'Update User'

          expect(current_path).to eq user_path(user)
          expect(page).to have_css('div.alert')
          expect(page).to have_no_css 'img.profile_picture'
        end
      end

      context '画像を設定していない場合' do
        it '画像を設定できる' do
          visit edit_user_path(user)

          attach_file 'user_new_profile_picture', "#{Rails.root}/spec/factories/profile1.png"

          click_on 'Update User'

          expect(current_path).to eq user_path(user)
          expect(page).to have_css('div.alert')
          expect(page).to have_css 'img.profile_picture'
          expect(page).to have_css "img[src$='profile1.png']"
        end
      end
    end
  end
end
