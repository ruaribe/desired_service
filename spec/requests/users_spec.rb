require 'rails_helper'

RSpec.describe 'Users', type: :request do

  describe 'GET /users' do
    before do
      @users = []
      10.times do
        @users << create(:user)
      end
    get '/users'
    end
    it 'リクエストが成功すること' do
      expect(response.status).to eq 200
    end

    it 'ユーザー名が表示されていること' do
      @users.each do |user|
        expect(response.body).to include user.name
      end
    end
  end
  describe 'GET /user/id' do
    context 'ユーザーが存在する場合' do
      before do
        @user = create(:user)
        get "/users/#{@user.id}"
      end
  
      it 'リクエストが成功すること' do
        expect(response.status).to eq 200
      end
  
      it 'ユーザー名が表示されていること' do
        expect(response.body).to include @user.name
      end
    end
    context 'ユーザーが存在しない場合' do
      it 'エラーになる' do
        expect{ get user_url(1) }.to raise_error ActiveRecord::RecordNotFound
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
    before do
      @user = create(:user)
    end

    it 'リクエストが成功すること' do
      get edit_user_url(@user.id)
      expect(response.status).to eq 200
    end


  end
  describe 'POST /users' do
    before do
      @user = build(:user)
    end

    context 'パラメータが妥当な場合' do
      before do
        @valid_params = attributes_for(:valid_user_params)
      end
      it 'リクエストが成功すること' do
        post '/users', params: {user: @valid_params}
        expect(response.status).to eq 302
      end
    
      it 'ユーザーが登録されること' do
        expect do
          post '/users', params: {user: @valid_params}
        end.to change(User, :count).by(1)
      end
    
      it 'リダイレクトすること' do
        post '/users', params: {user: @valid_params}
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが不正な場合' do
      before do
       @invalid_params = attributes_for(:invalid_user_params)
      end
      it 'リクエストが成功すること' do
        post '/users', params: {user:@invalid_params}
        expect(response.status).to eq 200
      end
      it 'ユーザーが登録されないこと' do
        expect do
          post '/users', params: {user: @invalid_params}
        end.to_not change(User, :count)
      end
    end
  end

  describe 'PATCH /users/id' do
    before do
      @user = create(:user)
    end

    context 'パラメータが妥当な場合' do
      before do
        @valid_params = attributes_for(:valid_user_params)
      end
      it 'リクエストが成功すること' do
        patch "/users/#{@user.id}", params: {user: @valid_params}
        expect(response.status).to eq 302
      end

      it 'ユーザー名が更新されていること' do
        expect do
          patch "/users/#{@user.id}", params: {user: @valid_params}
        end.to change { User.find(@user.id).name }.from(@user.name).to(@valid_params[:name])
      end
    
      it 'リダイレクトすること' do
        patch "/users/#{@user.id}", params: {user: @valid_params}
        expect(response).to redirect_to @user
      end
    end

    context 'パラメータが不正な場合' do
      before do
        @invalid_params = attributes_for(:invalid_user_params)
      end
      it 'リクエストが成功すること' do
        patch "/users/#{@user.id}", params: {user: @invalid_params}
        expect(response.status).to eq 200
      end

      it 'ユーザー名が更新されないこと' do
        expect do
          patch "/users/#{@user.id}" , params: { user: @invalid_params }
        end.to_not change(User.find(@user.id), :name)
      end
    end
  end
  describe 'DERETE /users/id' do
    before do
      @user = create(:user)
    end

    it 'リクエストが成功すること' do
      delete "/users/#{@user.id}"
      expect(response.status).to eq 302
    end

    it 'ユーザーが削除されること' do
      expect do
        delete "/users/#{@user.id}"
      end.to change(User, :count).by(-1)
    end

    it 'ユーザー一覧にリダイレクトすること' do
      delete "/users/#{@user.id}"
      expect(response).to redirect_to('/users')
    end
  end
end
