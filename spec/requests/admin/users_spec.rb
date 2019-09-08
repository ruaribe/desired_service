require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do
  let(:user) { create(:testuser) }
  let(:admin) { create(:testuser, :admin)}

  shared_examples '一般のトップページへリダイレクトされ、エラーメッセージが表示される' do
    it do
      expect(response).to redirect_to root_path
      expect(response.status).to eq 302
      follow_redirect!
      expect(response.body).to include 'アクセス権限がありません'
    end
  end

  describe 'get admin_users_path' do
    context 'ログインしていない場合' do
      before { get admin_users_path }
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '一般ユーザーの場合' do
      before do
        log_in_as(user)
        get admin_users_path
      end
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '管理ユーザーの場合' do
      let!(:users) { create_list(:user, 10, :sample) }
      before do
        log_in_as(admin)
        get admin_users_path
      end
      it 'リクエストに成功する' do
        expect(response.status).to eq 200
      end

      it 'ユーザーが表示されている' do
        users.each do |user|
          expect(response.body).to include user.name
        end
      end
    end
  end

  describe 'get user_path' do
    let(:otheruser) { create(:user, :sample) }
    context 'ログインしていない場合' do
      before { get admin_user_path(otheruser) }
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '一般ユーザーの場合' do
      before do
        log_in_as(user)
        get admin_user_path(otheruser)
      end
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '管理ユーザーの場合' do
      let!(:posted) { create(:post, user: otheruser) }
      before do
        log_in_as(admin)
        get admin_user_path(otheruser)
      end
      it 'リクエストに成功する' do
        expect(response.status).to eq 200
      end

      it 'other_userのページであることが表示されている' do
        expect(response.body).to include "#{otheruser.name}さんのページ"
      end
    end
  end

  describe 'delete user_path' do
    let!(:otheruser) { create(:user, :sample) }
    context 'ログインしていない場合' do
      before { delete admin_user_path(otheruser) }
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '一般ユーザーの場合' do
      before do
        log_in_as(user)
        delete admin_user_path(otheruser)
      end
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '管理ユーザーの場合' do
      let!(:posted) { create(:post, user: otheruser) }
      before { log_in_as(admin) }
      it 'リクエストが成功すること' do
        delete admin_user_path(otheruser)
        expect(response.status).to eq 302
      end
  
      it 'ユーザーが削除されること' do
        expect do
          delete admin_user_path(otheruser)
        end.to change(User, :count).by(-1)
      end
  
      it 'ユーザー一覧にリダイレクトすること' do
        delete admin_user_path(otheruser)
        expect(response).to redirect_to admin_users_path
      end
    end
  end
end
