require 'rails_helper'

RSpec.describe "users/show.html.erb", :type => :view do
  context "view profile" do
  	before (:each) do
  		@user = create(:user)
  	end
  	
  	it "shows the user name and screen name" do
  		render
  		assert_select 'h3',"Name: " + @user.name
  		assert_select 'h3',"Screen Name: " + @user.screen_name
  	end
  
  	it "shows the user is not a tester" do
  		render
  		assert_select "h3", {count: 0, text: "Tester"}
  	end         
  end
  context "profile of tester" do
  	it "shows the user is a tester" do
  		@user = create(:user, tester: true)
  		render
  		assert_select "h3", {count: 1, text: "Tester"}
  	end
  end		
  	
  		
end