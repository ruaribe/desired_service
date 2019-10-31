# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'いいね！機能', type: :system do
  before do
    driven_by(:rack_test)
  end
  let(:login_user) { create(:testuser) }
  let!(:my_post) { create(:post, :sample, user: login_user) }
  let(:other_user) { create(:user, :sample) }
  let!(:other_post) { create(:post, :sample, user: other_user) }

  context 'ログインしている時' do
    before do
      valid_login(login_user)
      visit posts_path
    end

    context '自分の投稿の場合' do
      it 'いいね機能のリンクが存在しない' do
        within ".post.post#{my_post.id}" do
          expect(page).to have_no_css '#like_link'
          expect(page).to have_no_css '#unlike_link'
          expect(page).to have_css '.fas.fa-heart'
          expect(page).to have_content 0
        end
      end
    end

    context '他のユーザーの投稿の場合' do
      context 'いいねしていない時' do
        it 'いいねすることができる' do
          within ".post.post#{other_post.id}" do
            expect(page).to have_css '#like_link'
            expect(page).to have_no_css '#unlike_link'
            expect(page).to have_css '.like_count', text: 0

            find('#like_link').click

            expect(page).to have_css '#unlike_link'
            expect(page).to have_no_css '#like_link'
            expect(page).to have_css '.like_count', text: 1
          end
          expect(page).to have_content 'いいね！しました。'
        end
      end

      context 'いいねしてある時' do
        before do
          within ".post.post#{other_post.id}" do
            find('#like_link').click
          end
        end
        it 'いいねを取消できる' do
          within ".post.post#{other_post.id}" do
            expect(page).to have_css '#unlike_link'
            expect(page).to have_no_css '#like_link'
            expect(page).to have_css '.like_count', text: 1

            find('#unlike_link').click

            expect(page).to have_css '#like_link'
            expect(page).to have_no_css '#unlike_link'
            expect(page).to have_css '.like_count', text: 0
          end
          expect(page).to have_content 'いいね！を取消しました。'
        end
      end
    end
  end

  context 'ログインしていない時' do
    before { visit posts_path }

    it '全ての投稿にいいね機能のリンクが存在しない' do
      expect(page).to have_no_css '#like_link'
      expect(page).to have_no_css '#unlike_link'
      expect(page).to have_css '.fas.fa-heart'
      expect(page).to have_content 0
    end
  end
end
