require 'rails_helper'

describe "observations/index.html.erb", :type => :view do
	it 'displays all observations' do
    assign(:observations, build_list(:observation, 10))

    render 

    assert_select "img", 10
  end
end
