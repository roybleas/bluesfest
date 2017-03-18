require 'rails_helper'

RSpec.describe "performances/edit.html.erb", :type => :view do
  describe "heading" do
  	before(:example) do
  		festival = create(:festival_with_stage_artist_performance)
  		performance = Performance.for_festival(festival).first
			assign(:performance, performance)
			@performance = performance
		  puts performance.inspect
  	end
  	it "has a title" do
  		render
	  	assert_select "h2", "Performance: #{@performance.title}" 
		end	
		it "has form labels" do
			render
			assert_select "label" , "Daynumber"
			assert_select "label" , "Duration"
			assert_select "label" , "Starttime"
			assert_select "label" , "Stage"
		end
	end
end