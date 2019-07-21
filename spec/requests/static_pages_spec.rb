require 'rails_helper'

RSpec.describe "StaticPages", type: :request do

  describe "GET /top" do
    it "render top" do
      get top_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /about" do
    it "render about" do
      get about_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /" do
    it "render top" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end
end
