 require 'rails_helper'
 
 feature 'log in user' do
 	background do 
 		@user = FactoryGirl.create(:user)
 	end
	
	scenario 'without a password' do
		user = FactoryGirl.build(:user, password: "")
		
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		
		expect(current_path).to eq login_path
		
		expect(page).to have_content 'Invalid name/password combination'
		# verify flash message cleared
		visit root_path
		expect(page).to_not have_content 'Invalid name/password combination'
		
	end
	
	scenario 'with a valid password and logout' do
				
		user = @user
						
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
		
		expect(current_path).to eq user_path(user.id)
		expect(page).to have_link("Profile")
		expect(page).to have_link("Log out")
		expect(page).to_not have_link("Log in")
		expect(page).to have_content(user.screen_name)

		click_link 'Log out'
		
		expect(current_path).to eq root_path
		expect(page).to_not have_link("Log out")
		expect(page).to have_link("Log in")
		expect(page).to_not have_content(user.screen_name)
		
	end
	
	scenario 'and not be remembered' do
		
		user = @user
		
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		uncheck('session_remember_me')
		click_button 'Log in'
		
		
		click_link 'Log out'
		
	end
	
	scenario 'and not be remembered' do
		user = @user
		
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		check("session_remember_me")
		click_button 'Log in'
		
		
		click_link 'Log out'
	end
end