 require 'rails_helper'
 
feature 'show users' do
 	background do 
 		@user = FactoryGirl.create(:user)
 		
 	end
	
	scenario 'as normal user' do
		
		user = @user
		
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		expect(current_path).to eq user_path(user.id)
		
	
		
		click_link 'Log out'
		
	end
	
	scenario 'as admin user' do
		user = @user
		admin = FactoryGirl.create(:admin_user)
		
		visit login_path
		fill_in "Name",							with: admin.name
		fill_in "Password",					with:	admin.password 
		click_button 'Log in'
		expect(current_path).to eq user_path(admin.id)
		
		visit users_path
		
		expect(page).to have_content(admin.screen_name)
		expect(page).to have_link("Delete", :href=>"/users/#{user.id}" )
		expect(page).to_not have_link("Delete", :href=>"/users/#{admin.id}" )
		
		click_link 'All Users'
		expect(current_path).to eq users_path
		
		expect(page).to have_content(user.screen_name)
		expect(page).to have_content(user.name)
		
		
		click_link 'Log out'
	end 
end
	