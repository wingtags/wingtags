require 'rails_helper'

describe ObservationForm do
  
	context "Complete observation" do
    xdescribe '#to_observation' do
      it 'should return an instantiated Observation object' do
        observation = FactoryGirl.build :observation
        form = FactoryGirl.build :observation_form

        subject = form.to_observation

        expect(subject.observed_at).to eq(observation.observed_at)
        expect(subject.latitude).to eq(observation.latitude)
        expect(subject.longitude).to eq(observation.longitude)
        expect(subject.animal).to eq(observation.animal)
        expect(subject.user).to eq(observation.user)
        expect(subject.address).to eq(observation.address)
      end
    end
  end

  context "Observation without image" do
    describe '#to_observation' do
      it 'should return an instantiated Observation object' do
        animal = FactoryGirl.create :animal 
        form = FactoryGirl.build(:observation_form, image: nil, tag: animal.tag_code)
        
        subject = form.to_observation
      end
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

  context "invalid observations" do
    # one of latitude and longitude are empty
  end
end