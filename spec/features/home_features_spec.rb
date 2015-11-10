require 'rails_helper'

feature 'Home page' do

  scenario "Visit Home page" do
		visit root_path
		expect(page).to have_content('Home Page')
	end
end
