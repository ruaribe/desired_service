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
end
