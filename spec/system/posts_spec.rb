require 'rails_helper'

RSpec.describe "Posts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:login_user) { create(:testuser) }
  let(:other_user) { create(:user, :sample) }

  describe '全投稿一覧表示' do
    let!(:posts) { create_list(:post, 20, :sample) }
    shared_examples '全ユーザーの投稿と投稿者が表示される' do
      it do
        posts.each do |post|
          expect(page).to have_content post.content
          expect(page).to have_link post.user.name
        end
      end
    end

    context 'ログインしているとき' do
      before do
        valid_login(login_user)
        visit posts_path
      end

      it_behaves_like '全ユーザーの投稿と投稿者が表示される'
    end

    context 'ログインしていない時' do
      before { visit posts_path }
      it_behaves_like '全ユーザーの投稿と投稿者が表示される'
    end
  end

  describe 'ユーザー詳細画面の投稿一覧表示' do
    let!(:other_posts) { create_list :post, 20, user: other_user }

    shared_examples 'そのページのユーザーの投稿一覧が表示される' do
      it do
        other_posts.each do |post|
          expect(page).to have_content post.content
        end
      end
    end

    context 'ログインしている時' do
      before do
        valid_login(login_user)
        visit user_path(other_user)
      end
      it_behaves_like 'そのページのユーザーの投稿一覧が表示される'
    end

    context 'ログインしていない時' do
      before { visit user_path(other_user) }

      it_behaves_like 'そのページのユーザーの投稿一覧が表示される'
    end
  end

  describe 'トップページの最新投稿表示' do
    let(:displayed_posts) { Post.order(created_at: :desc).limit(20) }
    before { create_list(:post, 21, :sample) }
    shared_examples '最新20件の投稿と投稿者が表示される' do
      it do
        displayed_posts.each do |post|
          expect(page).to have_content post.content
          expect(page).to have_link post.user.name
        end
      end
    end

    context 'ログインしている時' do
      before do
        valid_login(login_user)
        visit root_path
      end
      it_behaves_like '最新20件の投稿と投稿者が表示される'
    end

    context 'ログインしていない時' do
      before { visit root_path }
      it_behaves_like '最新20件の投稿と投稿者が表示される'
    end
  end

  describe 'トレンド表示機能' do
    let(:displayed_posts) { Post.find(Like.group(:post_id).order(Arel.sql('count(post_id) desc')).limit(20).pluck(:post_id)) }
    before do
      create_list(:post, 22, :sample)
      Post.take(21).each do |post|
        create(:like, user: other_user, post: post)
      end
    end

    shared_examples 'いいね！が付けられた数が多い順に20件表示される。' do
      it do
        displayed_posts.each do |post|
          expect(page).to have_content post.content
          expect(page).to have_content post.user.name
        end
      end
    end

    context 'ログインしている時' do
      before do
        valid_login(login_user)
        visit root_path
        click_on 'トレンド'
      end

      it_behaves_like 'いいね！が付けられた数が多い順に20件表示される。'
    end

    context 'ログインしていない時' do
      before do
        visit root_path
        click_on 'トレンド'
      end

      it_behaves_like 'いいね！が付けられた数が多い順に20件表示される。'
    end
  end

  describe '投稿機能' do
    before { valid_login(login_user) } 

    context '自分のページの場合' do
      before { visit user_path(login_user) }

      it '投稿フォームが存在する' do
        expect(page).to have_css('div.post_field')
      end

      context '有効な投稿の場合' do
        it '投稿され、ユーザー詳細ページへリダイレクトされること' do
          fill_in 'post_content', with: 'テスト投稿'
          expect do
            click_on '投稿'
          end.to change(Post, :count).by(1)

          expect(current_path).to eq user_path(login_user)
          expect(page).to have_content '投稿しました'
          expect(page).to have_content Post.last.content
        end
      end

      context '無効な投稿の場合' do
        it '投稿されずに、エラーメッセージが表示される' do
          fill_in 'post_content', with: '     '

          expect do
            click_on '投稿'
          end.to_not change(Post, :count)

          expect(page).to have_css('div.post_field')
          expect(page).to have_css('div#error_explanation')
        end
      end
    end

    context '他のユーザーのページの場合' do
      before { visit user_path(other_user) }

      it '投稿用のフォームがない' do
        expect(page).to_not have_css('div.post_field')
      end
    end
  end

  describe '投稿削除機能' do
    context '一般ユーザーでログインしているとき' do
      before { valid_login(login_user) }
      context '自分のページの場合' do
        let!(:my_post) { create(:post, user: login_user) }
        before { visit user_path(login_user) }
        it '削除リンクから削除できる' do
          expect(page).to have_content my_post.content
          expect(page).to have_link '削除'
          expect do
            click_on '削除', match: :first
          end.to change(Post, :count).by(-1)

          expect(page).to_not have_content my_post.content
        end
      end

      context '他のユーザーのページの場合' do
        let!(:other_post) { create(:post, user: other_user) }
        before { visit user_path(other_user) }

        it '削除リンクがない' do
          expect(page).to have_content other_post.content
          expect(page).to_not have_link '削除'
        end
      end

      context 'ユーザー詳細ページ以外のページの場合' do
        let!(:my_post) { create(:post, user: login_user) }

        it '自分の投稿であっても削除リンクは表示されない' do
          visit posts_path
          expect(page).to_not have_link '削除'

          visit top_path
          expect(page).to_not have_link '削除'

          visit root_path
          expect(page).to_not have_link '削除'
        end
      end
    end
  end
end
