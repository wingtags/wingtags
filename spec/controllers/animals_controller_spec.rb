require 'rails_helper'

describe AnimalsController, :type => :controller do

  

  describe "GET show" do

    before(:each) do
      @animal = FactoryGirl.create :animal
    end
    
    it "returns Animal JSON" do
      request.headers["Content-Type"] = "application/json"
      request.headers["Accept"] = "application/json"

      get(:show, { 'id' => @animal.id })

      expect(response).to have_http_status(:success)
      expect(response.body).to include(@animal.name)
    end
  end

  describe "#index" do
    it "assigns @animals" do
      animals = create_list(:animal, 10)
      get :index
      expect(assigns(:animals)).to match_array(animals)
    end
  end

  describe "#index" do
    it "renders index.html.erb" do
      animals = create_list(:animal, 10)
      get :index
      expect(response).to render_template("index")
    end
  end
end
