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
  
  end
  	
  		
end