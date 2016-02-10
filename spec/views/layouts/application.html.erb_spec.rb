require 'rails_helper'

RSpec.describe "layouts/application.html.erb", :type => :view do
	
	
	context "navigation menu" do
			
		it "has a Home tab" do
			render
			assert_select 'a', "Home"
			assert_select "a[href=?]", "/"
		end
		it "has an About tab" do
			render
			assert_select 'li', "About"
			assert_select "a[href=?]", "/"
		end
		it "has a Artists tab" do
			render
			assert_select 'li',"Artists"
		end
	end
	context "navigate when not logged in" do
		before(:each) do
			allow(view).to receive_messages(:logged_in? => false)
		end
		
		it "has a link to log in" do
			render
			assert_select 'li', "Log in"
			assert_select "a[href=?]", "/login"
		end
	end
	context "navigate when logged in" do
		before(:each) do
			allow(view).to receive_messages(:logged_in? => true)
			@user = create(:user)
			allow(view).to receive(:current_user).and_return(@user)
		end
		
		it "does not have a link to login" do
			render
			assert_select 'li', {:text=> "Log in", :count=> 0 }
		end
		it "has a user name" do
			render
			assert_select 'a.dropdown-toggle', /User:\s+#{@user.screen_name}/
		end
		it "has a link to profile" do
			render
			assert_select 'li', "Profile"
			assert_select "a[href=?]", "/users/" + @user.id.to_s
		end
		it "has a link to Log out" do
			render
			assert_select 'li', "Log out"
			assert_select "a[href=?]", "/logout" 
			assert_select "a[data-method=?]", "delete"
		end
	end
	context "navigate when logged in as admin" do
		before(:each) do
			allow(view).to receive_messages(:admin_user? => true)
			allow(view).to receive_messages(:logged_in? => true)
			@user = create(:user)
			allow(view).to receive(:current_user).and_return(@user)
		end
		it "has a heading of Admin" do
			render
			assert_select 'a.dropdown-toggle', "Admin"
		end
		it "has a link to all users list" do
			render
			assert_select 'li', "All Users"
			assert_select "a[href=?]", "/users"
		end
	end
	context "navigate when not logged in as admin" do
		before(:each) do
			allow(view).to receive_messages(:admin_user? => false)
			allow(view).to receive_messages(:logged_in? => true)
			@user = create(:user)
			allow(view).to receive(:current_user).and_return(@user)
		end
		
		it "does not have admin options" do
			render
			assert_select 'li', {:text=> "Admin", :count=> 0 }
			assert_select 'li', {:text=> "All Users", :count=> 0 }
		end
	end
	context "festival title" do
		it "has no title set" do
			render
			expect(rendered).to match /Festival not set/
		end
		it "has a title" do
			festival = create(:festival)
			render
			expect(rendered).to match /#{festival.title} #{festival.year}/
		end
	end
			
end