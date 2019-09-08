# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Posts', type: :request do
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

  describe 'get admin_posts_path' do
    context 'ログインしていないユーザーの場合' do
      before { get admin_posts_path }
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '一般ユーザーでログインしている場合' do
      before do
        log_in_as(user)
        get admin_posts_path
      end
      it_behaves_like '一般のトップページへリダイレクトされ、エラーメッセージが表示される'
    end

    context '管理者ユーザーでログインしている場合' do
      let!(:posts) { create_list(:post, 10, :sample) }
      before do
        log_in_as(admin)
        get admin_posts_path
      end
      it 'リクエストに成功する' do
        expect(response.status).to eq 200
      end

      it '投稿が表示されている' do
        posts.each do |post|
          expect(response.body).to include post.content
        end
      end
    end
  end

  describe 'delete admin_post_path' do

    shared_examples '投稿は削除されず、一般のトップページへリダイレクトされ、エラーメッセージが表示される' do
      it do
        expect do
          delete admin_post_path(posted)
        end.to_not change(Post, :count)
        expect(response).to redirect_to root_path
        expect(response.status).to eq 302
        follow_redirect!
        expect(response.body).to include 'アクセス権限がありません'
      end
    end

    shared_examples '投稿が削除される' do
      it do
        expect do
          delete admin_post_path(posted)
        end.to change(Post, :count).by(-1)
      end
    end

    context '自分の投稿に対して実行した場合' do
      context '一般ユーザーでログインしている場合' do
        let!(:posted) { create(:post, user: user) }
        before { log_in_as(user) }

        it_behaves_like '投稿は削除されず、一般のトップページへリダイレクトされ、エラーメッセージが表示される'
      end

      context '管理者ユーザーでログインしている場合' do
        let!(:posted) { create(:post, user: admin) }
        before { log_in_as(admin) }

        it_behaves_like '投稿が削除される'
      end
    end

    context '他のユーザーの投稿に対して実行した場合' do
      let!(:posted) { create(:post, :sample) }
      context 'ログインしていないユーザーの場合' do
        it_behaves_like '投稿は削除されず、一般のトップページへリダイレクトされ、エラーメッセージが表示される'
      end

      context '一般ユーザーでログインしている場合' do
        before { log_in_as(user) }

        it_behaves_like '投稿は削除されず、一般のトップページへリダイレクトされ、エラーメッセージが表示される'
      end

      context '管理者ユーザーでログインしている場合' do
        before { log_in_as(admin) }

        it_behaves_like '投稿が削除される'
      end
    end
  end
end
