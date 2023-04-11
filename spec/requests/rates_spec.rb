require 'rails_helper'

RSpec.describe "Rates", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/rates/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /force" do
    it "returns http success" do
      get "/rates/force"
      expect(response).to have_http_status(:success)
    end
  end

end
