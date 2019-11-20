require 'rails_helper'

RSpec.describe "PostImages", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { create(:testuser) }
  let!(:my_post) { create(:post, :sample, user: user) }
  let!(:image1) { create(:image, post: my_post) }

  describe '画像投稿機能' do
    before do
      valid_login(user)
      visit user_path(user)

      click_link '投稿の画像一覧'
    end

    it '投稿へ画像を追加する' do
      click_link '画像の追加'

      attach_file 'post_image_new_data', "#{Rails.root}/spec/factories/image2.jpg"
      fill_in 'post_image_alt_text', with: 'テスト'

      click_on '登録する'

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

      click_on '更新する'

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

  describe '画像表示順変更機能', :focus do
    let!(:iamge2) { create(:image, :image2, post: my_post) }

    before do
      valid_login(user)
      visit user_path(user)
    end

    it '画像が正しい位置に表示される' do
      within '.images_item1' do
        expect(page).to have_css "img[src$='image1.jpg']"
      end

      within '.images_item2' do
        expect(page).to have_css "img[src$='image2.jpg']"
      end
    end

    it 'image2を1つ前に移動させる' do
      click_link '投稿の画像一覧'

      within '.images_item2' do
        click_link '上へ'
      end

      expect(current_path).to eq post_images_path(my_post)

      within '.images_item1' do
        expect(page).to have_css "img[src$='image2.jpg']"
      end

      within '.images_item2' do
        expect(page).to have_css "img[src$='image1.jpg']"
      end

      visit user_path(user)

      within '.images_item1' do
        expect(page).to have_css "img[src$='image2.jpg']"
      end

      within '.images_item2' do
        expect(page).to have_css "img[src$='image1.jpg']"
      end

    end
    it 'image1を1つ後に移動させる' do
      click_link '投稿の画像一覧'

      within '.images_item1' do
        click_link '下へ'
      end

      expect(current_path).to eq post_images_path(my_post)

      within '.images_item1' do
        expect(page).to have_css "img[src$='image2.jpg']"
      end

      within '.images_item2' do
        expect(page).to have_css "img[src$='image1.jpg']"
      end

      visit user_path(user)

      within '.images_item1' do
        expect(page).to have_css "img[src$='image2.jpg']"
      end

      within '.images_item2' do
        expect(page).to have_css "img[src$='image1.jpg']"
      end

    end
  end
end