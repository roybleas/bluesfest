require 'rails_helper'
 
feature 'show admin' do
 	background do 
 		@adminuser = FactoryGirl.create(:admin_user)	
 	end
	
	scenario 'as admin user' do
		user = @adminuser
		
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		expect(current_path).to eq user_path(user.id)
		
		expect(page).to have_content("Admin")
	end
end	