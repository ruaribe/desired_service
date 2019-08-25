require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:login) { post login_path, params: { session: { email: login_user.email, password: login_user.password } } }
  let(:login_user) { create(:testuser) }

  describe 'GET /users' do
    let!(:users) { create_list :user, 10, :sample }

    context 'ログインしているとき' do
      before { login }

      it 'リクエストが成功すること' do
        get users_url
        expect(response.status).to eq 200
      end

      it 'ユーザー名が表示されていること' do
        get users_url
        users.each do |user|
          expect(response.body).to include user.name
        end
      end
    end
  end

  describe 'GET /user/id' do
    context 'ユーザーが存在する場合' do
      let(:user) { create(:user, :sample) }
      before { login }

      it 'リクエストが成功すること' do
        get "/users/#{user.id}"
        expect(response.status).to eq 200
      end

      it 'ユーザー名が表示されていること' do
        get "/users/#{user.id}"
        expect(response.body).to include user.name
      end
    end
    context 'ユーザーが存在しない場合' do
      it 'エラーになる' do
        expect { get user_url(1) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'GET /users/new' do
    it 'リクエストが成功すること' do
      get '/users/new'
      expect(response.status).to eq 200
    end
  end

  describe 'GET /edit_user_path' do
    before { login }

    it 'リクエストが成功すること' do
      get edit_user_url(login_user.id)
      expect(response.status).to eq 200
    end
  end

  describe 'POST /users' do
    context 'パラメータが妥当な場合' do
      let(:valid_params) { attributes_for(:testuser) }

      it 'リクエストが成功すること' do
        post '/users', params: { user: valid_params }
        expect(response.status).to eq 302
      end

      it 'ユーザーが登録されること' do
        expect do
          post '/users', params: { user: valid_params }
        end.to change(User, :count).by(1)
      end

      it 'リダイレクトすること' do
        post '/users', params: { user: valid_params }
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが不正な場合' do
      let(:invalid_params) { attributes_for(:user, :invalid) }
      it 'リクエストが成功すること' do
        post '/users', params: { user: invalid_params }
        expect(response.status).to eq 200
      end
      it 'ユーザーが登録されないこと' do
        expect do
          post '/users', params: { user: invalid_params }
        end.to_not change(User, :count)
      end
    end
  end

  describe 'PATCH /users/id' do
    before { login }

    context 'パラメータが妥当な場合' do
      let(:valid_params) { attributes_for(:user, :sample) }
      it 'リクエストが成功すること' do
        patch "/users/#{login_user.id}", params: { user: valid_params }
        expect(response.status).to eq 302
      end

      it 'ユーザー名が更新されていること' do
        expect do
          patch "/users/#{login_user.id}", params: { user: valid_params }
        end.to change { User.find(login_user.id).name }.from(login_user.name).to(valid_params[:name])
      end

      it 'リダイレクトすること' do
        patch "/users/#{login_user.id}", params: { user: valid_params }
        expect(response).to redirect_to login_user
      end
    end

    context 'パラメータが不正な場合' do
      let(:invalid_params) { attributes_for(:user, :invalid) }
      it 'リクエストが成功すること' do
        patch "/users/#{login_user.id}", params: { user: invalid_params}
        expect(response.status).to eq 200
      end

      it 'ユーザー名が更新されないこと' do
        expect do
          patch "/users/#{login_user.id}", params: { user: invalid_params }
        end.to_not change(User.find(login_user.id), :name)
      end
    end
  end

  describe 'DERETE /users/id' do
    let!(:user) { create(:user, :sample) }
    before { login }
    it 'リクエストが成功すること' do
      delete "/users/#{user.id}"
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete "/users/#{user.id}"
      end.to change(User, :count).by(-1)
    end

    it 'ユーザー一覧にリダイレクトすること' do
      delete "/users/#{user.id}"
      expect(response).to redirect_to('/users')
    end
  end
end
