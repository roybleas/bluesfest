require 'rails_helper'

RSpec.describe "home_pages/next.html.erb", :type => :view do
  	context "Heading" do
	  before(:example) do
			assign(:performances, [])
			assign(:dayindex, 2)
	  end
	  it "has title" do
	  	render
	  	assert_select "h5","Coming Up Next"
	  end
	  it "has date as a title" do
	  	assign(:localTime_caption, "Sun 20 Mar 2016 12:07 PM")
	  	render 
	  	expect(rendered).to match /Sun 20 Mar 2016 12:07 PM/
		end
		it "has day number " do
	  	assign(:dayindex, 2)
	  	render 
	  	expect(rendered).to match /Day: 2/
		end
		it "has an invalid day number " do
	  	assign(:dayindex, 0)
	  	render 
	  	expect(rendered).to_not match /Day: 0/
		end
		
		it "has a panel" do
			render
		 	assert_select "div.panel",1
		end
		it "has refresh button" do
			render
			assert_select "a","Refresh"
			assert_select "a[href=?]", "/next"
		end
		it "has a Now button" do
			render
			assert_select "a","Now"
			assert_select "a[href=?]", "/now"
		end
		it "has a no more for today message" do
			render
			expect(rendered).to match /That is all for today./
		end
	end
	context "performances" do
		
	end

end
