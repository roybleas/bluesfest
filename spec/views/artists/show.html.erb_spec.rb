require 'rails_helper'
require 'date'

RSpec.describe "artists/show.html.erb", :type => :view do
  it "shows artist name" do
  	artist = create(:artist)
  	assign(:artist, artist)
  	assign(:performances,[])
  	render
  	expect(rendered).to match /#{artist.name}/
  end
  it "shows missing artist" do
  	render
  	expect(rendered).to match /Unknown Artist/
  end
  context "performances" do
  	before(:each) do
  		performance = create(:performance_with_festival)
  		@performances = [performance]
  		@artist = Artist.first
  	end
  	it "shows stage name" do
  		stage = Stage.first
  		assign(:stage,stage)
  		render
  		expect(rendered).to match /#{stage.title}/
  	end
  	it "shows link to stage" do
  		stage = Stage.first
  		assign(:stage,stage)
  		@performances[0].daynumber = 2
  		render
  		expect(rendered).to match /<a class="stagelink" href="\/stages\/#{stage.id}\/2">Mojo<\/a>/
  	end
  	it "shows stage class set to stage code" do
  		stage = Stage.first
  		assign(:stage,stage)
  		render
  		expect(rendered).to match /id="color-#{stage.code}"/
  	end
  	it "shows day number" do
  		@performances[0].daynumber = 2
  		render
  		expect(rendered).to match /Day: 2/ 
		end
		it "shows day of week" do
			@performances[0].daynumber = 2
			assign(:startdate_minus_one, Date.new(2016,4,1))
			render
			expect(rendered).to match /Sun/
		end
  end
end

