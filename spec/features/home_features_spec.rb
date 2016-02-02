require 'rails_helper'

feature 'Home page' do
	include ActiveSupport::Testing::TimeHelpers
  scenario "Visit Home page" do
  	festival = create(:festival)
  	d = festival.startdate.prev_day(2)
  	Time.zone = "Sydney"
  	test_time = Time.new(d.year,d.month, d.day, 14, 20)
		travel_to(test_time)
		visit root_path
		expect(page).to have_content(test_time.strftime("%a %d %b %Y %I:%M %p"))
		expect(page).to have_content("Only 2 days to go!")
	end
end
