require 'rails_helper'

describe ObservationsController do

  describe 'POST #create' do
    #before(:each) do
      
    #end

    # it { should respond_with(:success) }
    it 'should response with success' do
      @form_data = FactoryGirl.build(:valid_observation)
      post :create, {:format => 'json', :observation => @form_data }

      expect(response.status).to eq(200)
    end
  end
end

#RSpec.describe ObservationsController, :type => :controller do
#
#  describe "GET index" do
#    it "returns http success" do
#      get :index
#      expect(response).to have_http_status(:success)
#    end
#  end
#
#  describe "POST #create" do
#    #let(:observation) { }
#
#  	it "returns the json object after creation" do
#      #binding.pry
#      post :create, { observation: FactoryGirl.attributes_for(:valid_observation) }, { "Accept" => "application/json", "Content-Type" => "application/json" }
#      expect(response.status).to eq 200
#  	end
#  end
#
#  context "valid observations" do
#    
#  end
#end
