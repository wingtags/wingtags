require 'rails_helper'

describe "animals/_animal.html.erb", :type => :view do
  it "displays one observation" do
    animal = build(:animal)

    render "animals/animal", :animal => animal

    expect(rendered).to have_content animal.name
    expect(rendered).to have_content animal.tag_code
    expect(rendered).to have_content animal.gender
  end
end
