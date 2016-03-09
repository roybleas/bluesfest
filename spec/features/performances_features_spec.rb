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
end
