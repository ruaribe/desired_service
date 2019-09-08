require 'rails_helper'

RSpec.describe "Admin::Posts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:admin) { create(:testuser, :admin) }

  describe '投稿削除機能' do
    context '管理者ユーザーでログインしている場合' do

      let!(:posts) { create_list(:post, 9, :sample) }
      let!(:user_post) { create_list(:post, 9, user: destroyed_post.user) }
      let!(:displayd_post) { Post.all.order(created_at: :desc) }
      let!(:destroyed_post) { Post.order(created_at: :desc).first }

      before { valid_login(admin) }

      it '投稿一覧画面で投稿を削除する' do
        visit admin_posts_path

        displayd_post.each do |post|
          expect(page).to have_link post.user.name, href: admin_user_path(post.user)
          expect(page).to have_link '削除', href: admin_post_path(post)
        end

        expect(page).to have_content destroyed_post.content

        expect do
          click_on '削除', match: :first
        end.to change(Post, :count)
        expect(current_path).to eq admin_posts_path

        expect(page).to have_no_content destroyed_post.content
      end

      it 'ユーザー詳細画面で投稿を削除する' do
        visit admin_user_path(destroyed_post.user)

        user_post.each do |post|
          expect(page).to have_link '削除', href: admin_post_path(post)
        end

        expect(page).to have_content destroyed_post.content
        expect(page).to have_link '削除', href: admin_post_path(destroyed_post)

        expect do
          click_on '削除', match: :first
        end.to change(Post, :count)
        expect(current_path).to eq admin_user_path(user_post[8].user)
        expect(page).to have_no_content user_post[8].content
      end
    end
  end
end
