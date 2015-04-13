require 'rails_helper'

describe ObservationForm do
  
	context "valid observations" do

    describe '#to_observation' do
      #subject(:form) { FactoryGirl.build :observation_form }
      let(:observation) { FactoryGirl.build :observation }

      it 'should return an instantiated Observation object' do
        observation = FactoryGirl.build :observation
        form = FactoryGirl.build :observation_form
        obs = form.to_observation
        expect(obs.observed_at).to eq(observation.observed_at)
      end
    end

    #describe '#save' do
    #  it "should save" do
    #    user = FactoryGirl.create :user
    #    animal = FactoryGirl.create :animal
    #    form = FactoryGirl.build :observation_form
#
    #    form.tag_code = animal.tag_code
    #    form.user_id = user.id
#
    #    form.save
#
    #    expect(Observation.all.count).to eq 1
    #  end
    #end
  end

  context "invalid observations" do
    # one of latitude and longitude are empty
  end
end