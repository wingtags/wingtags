require 'rails_helper'

describe User do
  describe '#save' do
    it 'should save' do
      args = FactoryGirl.attributes_for :user

      user = User.new(args)
      user.save

      expect(user.persisted?).to be(true)
    end

    it 'should save the required schema' do
      user = FactoryGirl.create(:user)

      json = NoBrainer.run { |r| r.table('Spotter').get('88c0cd22-6b7e-4bfc-9914-2a9fce61d36b'); }
      path = File.expand_path("../resources/schemas/user.schema.json", File.dirname(__FILE__))
      schema = File.read(path)

      expect(JSON::Validator.validate(schema, json)).to be(true), lambda { JSON::Validator.fully_validate(schema, json) }
    end
  end
end