require 'rails_helper'

feature 'show about' do
	
	scenario 'with active festival' do
		festival = create(:festival, major: 3, minor: 4, scheduledate: "2016-1-12")
		visit root_path
		click_link 'About'
		
		expect(current_path).to eq about_path
		
		expect(page).to have_link("Bluesfest")
		expect(page).to have_content("downloaded on: 12 January 2016")
		expect(page).to have_content("Version: 3.4")
	end
end
