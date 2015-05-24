require 'rails_helper'

describe "animals/index.html.erb", :type => :view do
  it "displays one observation" do
    assign(:animals, build_list(:animal, 10))

    render
    
    assert_select "ul" do
      assert_select "li", 10
    end
  end
end
