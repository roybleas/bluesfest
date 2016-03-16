require 'rails_helper'
require 'support/loginhelper'

RSpec.configure do |c|
  c.include LoginHelper
end

feature 'show index' do
 	background do 
 		@user = create(:user)	
 	end
	
	scenario 'with active festival but no favourites' do
		
		festival = create(:festival, major: 3, minor: 4, scheduledate: "2016-1-12")
				
		do_login(@user.name,@user.password)
	
		visit root_path
		click_link 'Favourites'
		
		expect(current_path).to eq favadd_path('a')
		
	end

	scenario 'with active festival and favourites' do
		create(:favourite, user_id: @user.id)
		
		festival = create(:festival, major: 3, minor: 4, scheduledate: "2016-1-12")
				
		do_login(@user.name,@user.password)
	
		visit root_path
		click_link 'Favourites'
		
		expect(current_path).to eq favourites_path
		
	end
	
end
