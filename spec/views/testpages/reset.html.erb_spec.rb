require 'rails_helper'

RSpec.describe "testpages/reset.html.erb", :type => :view do
	it "has a title " do
		render
		assert_select "h1","Test Time Settings"
	end
  it "shows current local time" do
  	assign(:localTime_caption, "Sun 20 Mar 2016 12:07 PM")
  	render 
  	expect(rendered).to match /Local Time: Sun 20 Mar 2016 12:07 PM/
  end
	it " shows message that time test has been reset" do
		render
		expect(rendered).to include "Test time reset."
	end
end