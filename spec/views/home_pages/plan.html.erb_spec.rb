require 'rails_helper'

RSpec.describe "home_pages/plan.html.erb", :type => :view do
  before(:example) do
  	assign(:festivaldays,5)
  	assign(:performances,[])
  end
  it "has date as a title" do
  	assign(:localTime_caption, "Sun 20 Mar 2016 12:07 PM")
  	render 
  	expect(rendered).to match /Sun 20 Mar 2016 12:07 PM/
	end
	it "has links for number of festival days" do
		render
		assert_select "a[href=?]", "/favourites/day/1"
		assert_select "a[href=?]", "/favourites/day/5"
		assert_select "a", "Day 5"
	end

end
