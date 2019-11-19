require 'rails_helper'

RSpec.describe "PostImages", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '画像投稿機能' do
    let(:user) { create(:testuser) }
    let!(:my_post) { create(:post, :sample, user: user) }
    let!(:image) { create(:image, post: my_post) }

    before do
      valid_login(user)
      visit user_path(user)

      expect(page).to have_css "img[src$='image1.jpg']"
      click_link '投稿の画像一覧'
    end

    it '投稿へ画像を追加する' do
      click_link '画像の追加'

      attach_file 'post_image_new_data', "#{Rails.root}/spec/factories/image2.jpg"
      fill_in 'post_image_alt_text', with: 'テスト'

      click_on 'Create Post image'

      expect(current_path).to eq post_images_path(my_post)
      expect(page).to have_css 'div.alert.alert-success', text: '画像を追加しました。'
      expect(page).to have_css "img[src$='image2.jpg']"

      visit user_path(user)

      expect(page).to have_css "img[src$='image2.jpg']"
    end

    it '投稿の画像を変更する' do
      expect(page).to have_css "img[src$='image1.jpg']"

      click_link '編集'

      attach_file 'post_image_new_data', "#{Rails.root}/spec/factories/image2.jpg"
      fill_in 'post_image_alt_text', with: 'テスト'

      click_on 'Update Post image'

      expect(current_path).to eq post_images_path(my_post)
      expect(page).to have_css 'div.alert.alert-success', text: '画像を更新しました。'
      expect(page).to have_css "img[src$='image2.jpg']"
      expect(page).to have_no_css "img[src$='image1.jpg']"

      visit user_path(user)

      expect(page).to have_css "img[src$='image2.jpg']"
      expect(page).to have_no_css "img[src$='image1.jpg']"
    end

    it '投稿の画像を削除する' do
      expect(page).to have_css "img[src$='image1.jpg']"

      click_link '削除'

      expect(current_path).to eq post_images_path(my_post)
      expect(page).to have_css 'div.alert.alert-success', text: '画像を削除しました。'
      expect(page).to have_no_css "img[src$='image1.jpg']"
      expect(page).to have_content '画像がありません'

      visit user_path(user)

      expect(page).to have_no_css "img[src$='image1.jpg']"
    end
  end
end
