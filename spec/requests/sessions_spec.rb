require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  let(:test_user) { create(:testuser) }

  describe 'GET /login' do
    it 'リクエストが成功すること' do
      get login_path
      expect(response.status).to eq 200
    end
  end

  describe 'POST /login' do
    context 'remember_meが1の時' do
      it 'cookiesにremember_tokenが保存されていること' do
        log_in_as(test_user, 1)
        expect(response.status).to eq 302
        expect(response).to redirect_to(user_url(test_user))
        expect(response.cookies['remember_token']).to_not eq nil
      end
    end

    context 'remember_meが0の時' do
      it 'cookiesにremember_tokenが保存されていないこと' do
        log_in_as(test_user, 0)
        expect(response.status).to eq 302
        expect(response).to redirect_to(user_url(test_user))
        expect(response.cookies['remember_token']).to eq nil
      end
    end
  end

  describe 'DELETE /logout' do
    context 'remember_meを1にしてログインしている場合' do
      it 'リクエストが成功し、ルートパスへリダイレクトされ、remember_tokenが削除されること' do
        log_in_as(test_user, 1)
        expect(response.cookies['remember_token']).to_not eq nil
        delete logout_path(test_user)
        expect(response.status).to eq 302
        expect(response).to redirect_to(root_url)
        expect(response.cookies['remember_token']).to eq nil
      end
    end

    context 'remember_meを0にしてログインしている場合' do
      it 'リクエストが成功し、ルートパスへリダイレクトされること' do
        log_in_as test_user
        delete logout_path(test_user)
        expect(response.status).to eq 302
        expect(response).to redirect_to(root_url)
      end
    end
  end

  context 'ログインしていない場合' do
    it 'トップページへ移動すること' do
      delete logout_path(test_user)
      expect(response).to redirect_to(root_url)
    end
  end
end
