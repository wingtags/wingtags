require 'rails_helper'

describe ObservationForm do
  subject(:observation) { FactoryGirl.build :observation_form }

	context "valid observations" do
    it "should validate" do
      expect(observation.valid?).to be true
    end

    describe '#save' do
      it "should save" do
        user = FactoryGirl.create :user
        animal = FactoryGirl.create :animal
        form = FactoryGirl.build :observation_form

        form.tag_code = animal.tag_code
        form.user_id = user.id

        form.save

        expect(Observation.all.count).to eq 1
      end
    end
  end

  context "invalid observations" do
    # one of latitude and longitude are empty
  end
end