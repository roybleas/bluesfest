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
	  	assign(:performances,[])
	  	render
	  	expect(rendered).to match /#{stage.title}/
	  end
  end
  context "show day and date information" do
  	before(:each) do
  		stage = create(:stage)
  		assign(:stage, stage)
  		assign(:stages, [stage])
  		assign(:performances,[])
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
	context "performance" do
		before(:each) do
			@performance = create(:performance_with_festival)
			performances = Performance.all
			stage = Stage.first
			@artist = Artist.first
			assign(:stage, stage)
			assign(:stages,Stage.all)
			assign(:days,5)
			assign(:dayindex,1)
			assign(:performances, performances) 
		end
		it "shows start time" do
			render
			expect(rendered).to match /19:15/ 
		end
		it "shows artist" do
			render
			artist_name = @artist.name
			artist_id = @performance.artist_id
			expect(rendered).to match /<a href="\/artists\/#{artist_id}">#{artist_name}<\/a>/
		end
		it "shows link to external website" do
			link_id = @artist.linkid
			render
			expect(rendered).to match /http:\/\/www.bluesfest.com.au\/schedule\/detail.aspx\?ArtistID=#{link_id}/
		end
		it "shows duration" do
			render
			expect(rendered).to match /(60 mins)/
		end
		
	end
end
