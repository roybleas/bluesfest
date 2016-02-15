require 'rails_helper'

RSpec.describe "stages/show.html.erb", :type => :view do
  it "shows missing artist" do
  	render
  	expect(rendered).to match /Unknown Stage/
  end
	context "stage selection table" do
		before(:each) do
			assign(:days, 5)
		end	
	   it "shows stage title" do
	  	stage = create(:stage)
	  	assign(:stage, stage)
	  	assign(:dayindex, 1)
	  	assign(:stages, [stage])
	  	render
	  	expect(rendered).to match /#{stage.title}/
	  end
  end
  context "show day and date information" do
  	before(:each) do
  		stage = create(:stage)
  		assign(:stage, stage)
  		assign(:stages, [stage])
  		assign(:days, 5)
  	end
  	it "shows the day number" do
  		assign(:dayindex, 1)
  		render
  		expect(rendered).to match /Day: 1/
  	end
  	it "shows the day of week" do
  		assign(:dayofweek, "Fri 25 Mar")
  		assign(:dayindex, 1)
  		render
  		expect(rendered).to match /\( Fri 25 Mar \)/
  	end

	end	
end
