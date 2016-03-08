require 'rails_helper'

feature 'show artists' do
	
	scenario 'with active festival' do
		festival = create(:festival, major: 3, minor: 4, scheduledate: "2016-1-12")
		visit root_path
		click_link 'Artists'
		
		expect(current_path).to eq artistsbypage_path('a')
		
	end
	scenario 'with active festival and artist' do
		festival = create(:festival_with_artist_and_page)
		visit root_path
		click_link 'Artists'
		
		expect(current_path).to eq artistsbypage_path('a')
		expect(page).to have_content("Tom Jones")
	end
end
