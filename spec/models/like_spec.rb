require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validates' do
    let(:user) { create(:testuser) }
    let(:other_user) { create(:user, :sample) }
    let(:post) { create(:post, user: other_user) }
    let(:like) { create(:like, user: user, post: post) }

    context '有効な場合' do
      it 'user_idとpost_idがそろっている' do
        expect(like).to be_valid
      end

      context 'リレーションが正しく行われているとき' do
        it 'ユーザー名が一致すること' do
          expect(like.user.name).to eq user.name
        end

        it '投稿の内容が一致すること' do
          expect(like.post.content).to eq post.content
        end
      end
    end

    context '無効な場合' do
      it 'user_idが存在しない' do
        like.user_id = nil
        expect(like).to_not be_valid
      end

      it 'post_idが存在しない' do
        like.post_id = nil
        expect(like).to_not be_valid
      end
    end
  end
end
