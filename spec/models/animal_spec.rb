require 'rails_helper'

describe Animal do
	describe '#new' do
    it 'should default tag_colour to yellow' do
    	animal = Animal.new
      expect(animal.tag_colour).to eq(TagColours::YELLOW)
    end
  end
end
