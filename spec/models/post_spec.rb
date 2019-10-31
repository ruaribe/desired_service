require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validates' do

    it '有効な投稿' do
      post = build :post
      expect(post).to be_valid
    end

    it '2000文字を超える投稿は無効' do
      post = build :post, content: 'a' * 2001
      expect(post).to_not be_valid
    end

    it 'ユーザーIDがない投稿は無効' do
      post = build :post, user_id: nil
      expect(post).to_not be_valid
    end

    it 'contentが空白は無効' do
      post = build :post, content: '  '
      expect(post).to_not be_valid
    end
  end

  describe 'associated' do
    let(:post) { create(:post, :sample) }
    let(:user) { create(:user, :sample) }
    it '投稿が削除されたらその投稿のいいねも削除される' do
      post.likes.create!(user: user)
      expect do
        user.destroy
      end.to change(Like, :count).by(-1)
    end
  end
end
