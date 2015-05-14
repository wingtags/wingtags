require 'rails_helper'
require 'json-schema'

describe Animal do
	describe '#new' do
    it 'should default tag_colour to yellow' do
    	animal = Animal.new
      expect(animal.tag_colour).to eq(TagColours::YELLOW)
    end
  end

  describe '#save' do
    it 'should save' do
      args = FactoryGirl.attributes_for :animal

      animal = Animal.new(args)
      animal.save

      expect(animal.persisted?).to be(true)
    end

    it 'should persist data according to the required schema' do
      animal = FactoryGirl.create(:animal)

      json = NoBrainer.run { |r| r.table('Wildlife').get('126'); }
      path = File.expand_path("../resources/schemas/animal.schema.json", File.dirname(__FILE__))
      schema = File.read(path)

      expect(JSON::Validator.validate(schema, json)).to be(true), lambda { JSON::Validator.fully_validate(schema, json) }
    end
  end
end
