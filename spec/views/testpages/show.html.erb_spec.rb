require 'rails_helper'

RSpec.describe "testpages/showtime.html.erb", :type => :view do
	it "has a title " do
		render
		assert_select "h1","Test Time Settings"
	end
  it "shows current local time" do
  	assign(:localTime_caption, "Sun 20 Mar 2016 12:07 PM")
  	render 
  	expect(rendered).to match /Local Time: Sun 20 Mar 2016 12:07 PM/
  end
  context "Session test_time" do
  	it "returns No test time message when session value is nil" do 
  		assign(:test_time,nil)
  		render
  		expect(rendered).to match /No test time set./
  		assert_select "p","No test time set"
  	end
  	it "returns test time message when session value is set" do 
  		sessiontime = Time.new(2016, 3, 31, 18,30)
  		assign(:test_time, sessiontime)
  		assign(:test_time_caption, sessiontime.strftime("%a %d %b %Y %I:%M %p"))
  		render
  		expect(rendered).to match /Test Time: #{sessiontime.strftime("%a %d %b %Y %I:%M %p")}/
  	end

  end
end
