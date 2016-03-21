require 'rails_helper'

RSpec.describe "home_pages/home.html.erb", :type => :view do
  it "has date as a title" do
  	assign(:localTime_caption, "Sun 20 Mar 2016 12:07 PM")
  	render 
  	expect(rendered).to match /Sun 20 Mar 2016 12:07 PM/
	end
	it "shows days to go message" do
  	assign(:days2go , "Starts Tomorrow!")
  	render 
  	expect(rendered).to match /Starts Tomorrow/
	end
	
end
