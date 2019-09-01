require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:testuser) }
  let!(:posts) { create_list(:post, 20, :sample) }
  describe 'get posts_path' do
    context 'ログインしている場合' do
      before { log_in_as(user) }

      it 'リクエストが成功すること' do
        get posts_path
        expect(response.status).to eq 200
      end
    end

    context 'ログインしていない場合' do
      it 'リクエストが成功すること' do
        get posts_path
        expect(response.status).to eq 200
      end
    end
  end

  describe 'post posts_path' do
    context 'ログインしている場合' do
      before { log_in_as(user) }

      context '有効なパラメータの場合' do
        let(:valid_post) { attributes_for(:post, user: user) }
        it 'リクエストが成功すること' do
          post posts_path, params: { post: valid_post }
          expect(response.status).to eq 302
        end

        it '投稿が1件増えること' do
          expect do
            post posts_path, params: { post: valid_post }
          end.to change(Post, :count).by(1)
        end

        it 'ユーザー詳細ページへリダイレクトされること' do
          post posts_path, params: { post: valid_post }
          expect(response).to redirect_to user
        end
      end

      context '無効なパラメータの場合' do
        let(:invalid_post) { attributes_for(:post, content: '', user: user) }
        it 'リクエストが成功すること' do
          post posts_path, params: { post: invalid_post }
          expect(response.status).to eq 200
        end

        it '投稿が増えないこと' do
          expect do
            post posts_path, params: { post: invalid_post }
          end.to_not change(Post, :count)
        end
      end
    end

    context 'ログインしていない場合' do
      let(:valid_post) { attributes_for(:post, user: user) }

      it 'ログインページへリダイレクトされること' do
        post posts_path, params: { post: valid_post }
        expect(response).to redirect_to login_url
      end

      it '投稿が増えないこと' do
        expect do
          post posts_path, params: { post: valid_post }
        end.to_not change(Post, :count)
      end
    end
  end

  describe 'DELETE posts_path' do
    context 'ログインしている場合' do
      before do
        @user = user
        log_in_as(@user)
      end
      context '自分の投稿に対して実行した場合' do
        let!(:my_post) { create(:post, user: @user) }

        it 'リクエストが成功すること' do
          delete post_path(my_post)
          expect(response.status).to eq 302
        end

        it '投稿が削除されること' do
          expect do
            delete post_path(my_post)
          end.to change(Post, :count).by(-1)
        end

        it 'root_urlへリダイレクトされること' do
          delete post_path(my_post)
          expect(response).to redirect_to root_url
        end
      end

      context '他のユーザーの投稿に対して実行した場合' do
        let!(:others_post) { create(:post, :sample) }

        it '投稿が削除されないこと' do
          expect do
            delete post_path(others_post)
          end.to_not change(Post, :count)
        end

        it 'root_urlへリダイレクトされること' do
          delete post_path(others_post)
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'ログインしていない場合' do
      let!(:others_post) { create(:post, :sample) }
      it 'ログインページへ移動すること' do
        delete post_path(others_post)
        expect(response).to redirect_to login_url
      end
    end
  end
end
