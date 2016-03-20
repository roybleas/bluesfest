require 'rails_helper'

RSpec.describe "testpages/settime.html.erb", :type => :view do
  it "has a title " do
		render
		assert_select "h1","Test Time New Settings"
	end
  it "shows current local time" do
  	assign(:localTime_caption, "Sun 20 Mar 2016 12:07 PM")
  	render 
  	expect(rendered).to match /Local Time: Sun 20 Mar 2016 12:07 PM/
  end
	it "shows the input parameters" do
		assign(:dayindex,2)
		assign(:hr,17)
		assign(:mins,28)
		render
		expect(rendered).to include("Parameters Day: 2 Hours: 17 Minutes: 28")
	end
	it "shows the new session time" do
		assign(:session_time_caption, "22 Mar 2016 16:09 PM") 
		render
		expect(rendered).to include("Session Test Time: 22 Mar 2016 16:09 PM")
	end
end
