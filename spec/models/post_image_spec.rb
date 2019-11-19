require 'rails_helper'

RSpec.describe PostImage, type: :model do
  describe 'validates' do
    let(:post) { create(:post, :sample) }

    context '新規作成の場合' do
      it '投稿と新しい画像があれば有効な状態であること' do
        image = PostImage.new(
          post: post,
          new_data: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'factories', 'image1.jpg'), 'image/jpeg')
        )
        expect(image).to be_valid
      end

      it '投稿がなければ無効な状態であること' do
        image = build(:image, post: post)
        image.post = nil
        image.valid?
        expect(image.errors).to be_added(:post, :blank)
      end

      it '新しい画像がなければ無効な状態であること' do
        image = build(:image, post: post)
        image.new_data = nil
        image.valid?
        expect(image.errors).to be_added(:new_data, :blank)
      end
    end

    context '更新の場合' do
      let(:image) { create(:image, post: post) }
      it '新しい投稿がなくても有効な状態であること' do
        image.new_data = nil
        expect(image).to be_valid
      end

      it '投稿がないと無効な状態であること' do
        image.post = nil
        image.valid?
        expect(image.errors).to be_added(:post, :blank)
      end
    end
  end
end
