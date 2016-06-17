require 'rails_helper'

RSpec.describe "performances/index.html.erb", :type => :view do
  describe "heading" do
  	before(:example) do
  		assign(:performances,[])
  	end
  	it "has a title" do
  		assign(:performancecount, 1)
  		render
	  	assert_select "h2", "Performance" 
		end	
  	it "has a plural title" do
  		assign(:performancecount, 2)
  		render
	  	assert_select "h2", "Performances" 
		end	
		it "has table headings" do
			render
			assert_select "thead" do |row|
				row.each do |headers|
					assert_select "td", 6
				end
			end
			assert_select "thead" do |row|
				row.each do |header|
					assert_select "td","Day"
					assert_select "td","Stage"
					assert_select "td","Start Time"
					assert_select "td","Performance"
					assert_select "td","Duration"
				end
			end
		end
	end
	describe "peformances " do
  	before(:example) do
  		festival = create(:festival_with_stage_artist_performance)
  		performances = Performance.for_festival(festival).includes(:artist, :stage)
  		@performance_id = performances[0].id
			assign(:performances,performances)
			assign(:performancecount, 1)
			
  	end
		it "shows table " do
			render
			assert_select "table.table-striped", {:count => 1}
		end	
		it "has performance details" do
			render
			assert_select "tbody" do |row|
				row.each do |element|
					assert_select "td", "1"
					assert_select "td", "Mojo"
					assert_select "td", "KENDRICK LAMAR"
					assert_select "td", "19:15"
					assert_select "td", "60 mins"
				end
			end
		end
		it "has link to edit performance" do
			render
			assert_select "a[href=?]", sprintf("/performances/%s/edit", @performance_id)
			assert_select "a", "Edit"
		end

	end
	
end