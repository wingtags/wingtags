require 'rails_helper'

describe ObservationForm do
  subject(:observation) { FactoryGirl.build :valid_observation }

	context "valid observations" do
    it "should validate" do
      expect(observation.valid?).to be true
    end
  end

  context "invalid observations" do
    # one of latitude and longitude are empty
  end
end