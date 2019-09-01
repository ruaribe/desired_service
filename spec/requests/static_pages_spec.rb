require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET top_path' do
    let!(:posts) { create_list(:post, 30, :sample) }
    it 'リクエストが成功する' do
      get top_path
      expect(response).to have_http_status(200)
    end

    it '20件分の最新の投稿が表示されている' do
      get top_path
      displayed_posts = Post.order(created_at: :desc).limit(20)
      displayed_posts.each do |post|
        expect(response.body).to include post.content
      end
    end

    it '21件目以降の投稿は表示されていない' do
      get top_path
      not_displeyed_posts = Post.order(created_at: :desc).offset(21)
      not_displeyed_posts.each do |post|
        expect(response.body).to_not include post.content
      end
    end
  end

  describe 'GET about_path' do
    it 'リクエストが成功する' do
      get about_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET root_path' do
    it 'リクエストが成功する' do
      get root_path
      expect(response).to have_http_status(200)
    end
  end
end
