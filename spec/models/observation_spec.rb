require 'rails_helper'
require 'json-schema'

describe Observation do

  before do
    Dragonfly.app.use_datastore(:memory)
  end

  describe '#save' do
    it 'should save' do
      args = FactoryGirl.attributes_for :observation

      observation = Observation.new(args)
      observation.save

      expect(observation.persisted?).to be(true)
    end

    it 'should save the required schema' do
      observation = FactoryGirl.create(:observation)

      json = NoBrainer.run { |r| r.table('Sighting').get('021e52d0-a6b0-4f0e-b861-5316de98e1f6'); }
      path = File.expand_path("../resources/schemas/observation.schema.json", File.dirname(__FILE__))
      schema = File.read(path)

      expect(JSON::Validator.validate(schema, json)).to be(true)
    end

    it 'should save an image' do
      observation = FactoryGirl.create(:observation)

      expect(observation.image.file).to be_instance_of(File)
    end

  end

  describe 'Persistence' do
    before(:each) do
      NoBrainer.run { |r| r.table('Sighting').insert({
        "Geom"=>{
          "$reql_type$"=>"GEOMETRY",
          "coordinates"=>[151.2274945145949, -33.87189375198408],
          "type"=>"Point"
        },
        "Latitude"=>-33.87189375198408,
        "Location"=>"Greenknowe Avenue\nElizabeth Bay 2011\nNSW",
        "Longitude"=>151.2274945145949,
        "Notes"=>"Cockatoo with tag 088 spotted at:\nGreenknowe Avenue\nElizabeth Bay 2011\nNSW",
        "SightingDate"=>1406787692246,
        "SightingID"=>"011bb59f-4825-48f9-9062-360258ba6cf9",
        "SpotterID"=>"90",
        "WildlifeID"=>"113"}
      )}
    end

    it 'Observation.observed_at should return a Time object' do
      observation = Observation.find("011bb59f-4825-48f9-9062-360258ba6cf9")
      expect(observation.observed_at).to eq(Time.at(1406787692))
    end

    it 'Observation.observed_at= should accept a Time object and persist an Integer' do
      observation = Observation.find("011bb59f-4825-48f9-9062-360258ba6cf9")
      observation.observed_at = Time.utc(2014, 1, 1, 0, 0, 0)
      observation.save

      record = NoBrainer.run { |r| r.table('Sighting').get("011bb59f-4825-48f9-9062-360258ba6cf9") }
      expect(record["SightingDate"]).to equal(1388534400000)
    end
  end
end

