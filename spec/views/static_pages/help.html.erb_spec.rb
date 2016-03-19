require 'rails_helper'

RSpec.describe "static_pages/help.html.erb", :type => :view do
  it "displays the help page" do
  	render
  	expect(rendered).to match /Help/
  end
  context "links to " do
  	it "Stages" do
  		render
  		assert_select "a","Stages"
  		assert_select "a[href=?]", stages_path
  	end
  	it "Day 1"  do
  		render
  		assert_select "a","Day 1"
  		assert_select "a[href=?]", stage_path(2,1)
  	end
  	it "Artists"  do
  		render
  		assert_select "a","Artists"
  		assert_select "a[href=?]", artists_path
  	end
  	it "I button" do
  		render
  		assert_select "a", "i"
  		assert_select "a[href=?]", "http://www.bluesfest.com.au/schedule/detail.aspx?ArtistID=793"
  		assert_select "a.bluelink", {:count => 1}
  	end
  	it "Sign up" do
  		render
  		assert_select "a", "Sign up"
  		assert_select "a[href=?]", signup_path
  	end
  		
  	it "Log in" do
  		render
  		assert_select "a", "Log in"
  		assert_select "a[href=?]", login_path
  	end
  	
  	it "has 2 Artist links" do
  		render
  		assert_select "a", "Artists" do
  			assert_select "a", {:count=>2}, "Missing artist link"
  		end
  	end
  		  	
  	it "Bluesfest home" do
  		render
  		assert_select "a","Bluesfest"
  		assert_select "a[href=?]", root_path
  	end
  end
  context "glyphicons" do
  	it "has a tick" do
  		render
  		assert_select "span.glyphicon-ok", 1
  	end
  	
  	it "has a cross" do
  		render
  		assert_select "span.glyphicon-remove", 1
  	end
  end
end
