require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET top_path' do
    it 'リクエストが成功する' do
      get top_path
      expect(response).to have_http_status(200)
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
