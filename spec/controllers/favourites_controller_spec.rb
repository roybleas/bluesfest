require 'rails_helper'

RSpec.describe FavouritesController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET delete" do
    it "returns http success" do
      delete :destroy, id: 1
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET add" do
    it "returns http success" do
      get :add, letter: 'a'
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET day" do
    it "returns http success" do
      get :day, dayindex: 1
      expect(response).to have_http_status(:success)
    end
  end

end
