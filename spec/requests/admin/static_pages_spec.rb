require 'rails_helper'

RSpec.describe "Admin::StaticPages", type: :request do
  let(:user) { create(:testuser) }
  let(:admin) { create(:testuser, :admin) }

  shared_examples '一般のトップページへリダイレクトされ、エラーメッセージが表示される' do
    it do
      expect(response).to redirect_to root_path
      expect(response.status).to eq 302
      follow_redirect!
      expect(response.body).to include 'アクセス権限がありません'
    end
  end

  describe 'get admin_root_path' do
    context 'ログインしていないユーザーの場合' do
      before { get admin_root_path }
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '一般ユーザーの場合' do
      before do
        log_in_as(user)
        get admin_root_path
      end
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '管理者ユーザーの場合' do
      before { log_in_as(admin) }

      it 'リクエストが成功すること' do
        get admin_root_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
