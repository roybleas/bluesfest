require 'rails_helper'

feature 'sign up users' do
	
	scenario 'with a missing user name' do
		user = FactoryGirl.build(:user, name: nil)
		visit new_user_path
		
		fill_in "Name",							with: user.name
		fill_in "Screen name",			with: user.screen_name
		fill_in "Password",					with:	user.password 
		fill_in "Confirm password", with: user.password 
		
		click_button 'Create account'
		expect(page).to have_content 'Name can\'t be blank'
	
	end
	
	scenario 'with user name is too long' do
		user = FactoryGirl.build(:user, name: nil)
		visit new_user_path
	
		fill_in "Name",							with: ("a" * 51).to_s
		fill_in "Screen name",			with: user.screen_name
		fill_in "Password",					with:	user.password 
		fill_in "Confirm password", with: user.password 
		
		click_button 'Create account'
		expect(page).to have_content 'Name is too long'
	end
	
	scenario 'with screen name too long' do
		user = FactoryGirl.build(:user, screen_name: nil)
		visit new_user_path
	
		fill_in "Name",							with: user.name
		fill_in "Screen name",			with: ("a" * 21).to_s
		fill_in "Password",					with:	user.password 
		fill_in "Confirm password", with: user.password 
		
		click_button 'Create account'
		expect(page).to have_content 'Screen name is too long'
	end
	
	scenario 'with password too short' do
		user = FactoryGirl.build(:user)
		visit new_user_path
	
		fill_in "Name",							with: user.name
		fill_in "Screen name",			with: user.screen_name
		fill_in "Password",					with:	("a" * 5).to_s
		fill_in "Confirm password", with: user.password 
		
		click_button 'Create account'
		expect(page).to have_content 'Password is too short'
	end
	
	scenario 'with a valid user' do
		user = FactoryGirl.build(:user)
		visit signup_path
		expect {
			fill_in "Name",							with: user.name
			fill_in "Screen name",			with: user.screen_name
			fill_in "Password",					with:	user.password 
			fill_in "Confirm password", with: user.password 
			
			click_button 'Create account'
		}.to change(User, :count).by(1)
	
	end
	
		scenario 'with non unique name' do
		FactoryGirl.create(:user)
		
		user = FactoryGirl.build(:user)
		visit signup_path
	
		fill_in "Name",							with: user.name
		fill_in "Screen name",			with: user.screen_name
		fill_in "Password",					with:	user.password 
		fill_in "Confirm password", with: user.password 
		
		click_button 'Create account'
		expect(page).to have_content 'Name has already been taken'
	end
end



		