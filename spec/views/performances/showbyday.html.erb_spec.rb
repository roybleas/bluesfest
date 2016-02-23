require 'rails_helper'

RSpec.describe "performances/showbyday.html.erb", :type => :view do
  it "shows no performances message" do
  	assign(:performances,[])
  	assign(:dayindex, 2)
  	render 
  	expect(rendered).to match /No performances for day 2/
  end
  context "days navigation menu" do
  	before(:each) do
  		p = build(:performance)
  		assign(:performances,[p])
  	end
  	it "shows no Day pages if festival days not set" do
  		assign(:festivaldays, 0)
  		assign(:dayindex, 1)
  		render
  		assert_select "li", 2
  	end	
  	it "shows links for 2 days and link" do
  		assign(:dayindex, 2)
  		assign(:festivaldays, 2)
  		render
  		assert_select "ul" do
    		assert_select "li", 4 do
    			assert_select "a", 4
    		end
  		end 
		end
		it "shows link for each festival day" do
  		assign(:dayindex, 2)
  		assign(:festivaldays, 4)
  		render
    	assert_select "li", 6
		end
		it "shows index day page navigation as active " do
			assign(:dayindex, 2)
  		assign(:festivaldays, 3)
  		render
  		assert_select "li.active", { :count => 1 }
  		assert_select "li.active a",  "Day 2"
  	end
  	it "has pagination link" do
  		assign(:dayindex, 2)
  		assign(:festivaldays, 3)
  		render
  		assert_select "li a[href=?]", "/showbyday/1"
		end
  end

end
