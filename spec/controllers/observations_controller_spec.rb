require 'rails_helper'

#describe ObservationsController do
#
#  describe 'POST #create' do
#    #before(:each) do
#      
#    #end
#
#    # it { should respond_with(:success) }
#    it 'should response with success' do
#      form_data = FactoryGirl.build(:valid_observation)
#      post :create, {:format => 'json', :observation => form_data }
#
#      expect(response.status).to eq(200)
#    end
#  end
#end

describe ObservationsController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    before(:each) do
      #create :user
      create :animal
    end
    #let(:observation) { }

  	it "returns the json object after creation" do
      form = FactoryGirl.attributes_for(:observation_form)
      #binding.pry
      post :create, { observation: form }#, { "Accept" => "application/json", "Content-Type" => "multipart/form-data" }
      expect(response.status).to eq 200
  	end
  end
end
