require 'rails_helper'

feature 'show performances' do
	
	scenario 'with active festival' do
		festival = create(:festival, major: 3, minor: 4, scheduledate: "2016-1-12")
		visit root_path
		click_link 'Days'
		
		expect(current_path).to eq showbyday_path(1)
		
	end
	scenario 'with active festival and performance' do
		festival = create(:festival_with_stage_artist_performance)
		visit root_path
		click_link 'Days'
		
		expect(current_path).to eq showbyday_path(1)
		expect(page).to have_content("KENDRICK LAMAR")
	end
	
	scenario 'with active festival and performance' do
		festival = create(:festival_with_stage_artist_performance)
		visit root_path
		click_link 'Days'
		
		expect(current_path).to eq showbyday_path(1)
		expect(page).to have_content("KENDRICK LAMAR")
	end
	
end

feature 'index of performances' do
	scenario 'allow access with admin authority ' do
		user = create(:admin_user)	
		log_in_user(user)
		expect(current_path).to eq user_path(user.id)
		
		expect(page).to have_content("Admin")
		expect(page).to have_content("Edit Performances")
	end
	
	scenario 'deny access without admin authority ' do
		user = create(:user)	
		log_in_user(user)
		expect(current_path).to eq user_path(user.id)
		expect(page).to_not have_content("Edit Performances")
	end
	
	scenario 'view performance list' do
		user = create(:admin_user)	
		log_in_user(user)
		expect(current_path).to eq user_path(user.id)
		click_link "Edit Performances"
		expect(current_path).to eq performances_path
	end
	
	def log_in_user(user)
		visit root_path
		
		click_link 'Log in'
		
		expect(current_path).to eq login_path
		fill_in "Name",							with: user.name
		fill_in "Password",					with:	user.password 
		click_button 'Log in'
	end
end
