 require 'rails_helper'
 
 feature 'update user' do
 	background do 
 		@user = FactoryGirl.create(:user)
 	end
	
	scenario 'update the user name and re-login' do
				
		user = @user
						
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		
		expect(current_path).to eq user_path(user.id)
	
		click_link 'Settings'
		expect(current_path).to eq edit_user_path(user.id)
		fill_in "Name",							with: user.name + " Updated"

		click_button 'Update Account'
		
		expect(current_path).to eq user_path(user.id)
		expect(page).to have_content(user.name + " Updated")
		
		click_link 'Log out'
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name + " Updated"
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		
		expect(current_path).to eq user_path(user.id)
	end
	
	scenario 'update the user screen name' do
				
		user = @user
						
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		
		expect(current_path).to eq user_path(user.id)
	
		click_link 'Settings'
		expect(current_path).to eq edit_user_path(user.id)
		fill_in "Screen name",							with: user.screen_name + " Updated"

		click_button 'Update Account'
		
		expect(current_path).to eq user_path(user.id)
		expect(page).to have_content(user.screen_name + " Updated")
		
	end
	
	scenario 'update the user password and re-login' do
				
		user = @user
						
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		
		expect(current_path).to eq user_path(user.id)
	
		click_link 'Settings'
		expect(current_path).to eq edit_user_path(user.id)
		fill_in "Password",							with: "New password"
		fill_in "Confirm password",							with: "New password"

		click_button 'Update Account'
		
		expect(current_path).to eq user_path(user.id)
		expect(page).to have_content("Profile updated")
		
		click_link 'Log out'
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name 
		fill_in "Password",					with:	"New password" 
		click_button 'Log in'
		
		expect(current_path).to eq user_path(user.id)
	end
	
	scenario 'delete the user' do
				
		user = @user
						
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		
		expect(current_path).to eq user_path(user.id)
	
		click_link 'Settings'
		expect(current_path).to eq edit_user_path(user.id)
		

		click_link 'Delete'
		
		expect(current_path).to eq root_path
		expect(page).to have_content("User deleted")
		
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		
		expect(current_path).to eq login_path
		expect(page).to have_content 'Invalid name/password combination'
	end
end