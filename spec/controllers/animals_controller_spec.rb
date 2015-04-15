require 'rails_helper'

describe AnimalsController, :type => :controller do

  before(:each) do
    @animal = FactoryGirl.create :animal
  end

  describe "GET show" do
    it "returns Animal JSON" do
      request.headers["Content-Type"] = "application/json"
      request.headers["Accept"] = "application/json"

      get(:show, { 'id' => @animal.id })

      expect(response).to have_http_status(:success)
      expect(response.body).to include(@animal.name)
    end
  end
end
