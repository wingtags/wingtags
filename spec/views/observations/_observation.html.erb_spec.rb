require 'rails_helper'

describe "observations/_observation.html.erb", :type => :view do
  it "displays one observation" do
    observation = build(:observation)

    render "observations/observation", :observation => observation

    expect(rendered).to have_content "cockatoo"
  end
end