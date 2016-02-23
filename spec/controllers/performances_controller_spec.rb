require 'rails_helper'

RSpec.describe PerformancesController, :type => :controller do

  describe "GET showbyday" do
    it "returns http success" do
      get :showbyday, dayindex: 1
      expect(response).to have_http_status(:success)
    end
    it "returns empty array when no performances" do
    	get :showbyday, dayindex: 1
    	expect(assigns(:performances)).to be_empty
    end
  end
  context "Returns perfomance data" do
  	before(:each) do
    	performance = create(:performance_with_festival)
    	@performances = [performance]
    	get :showbyday, dayindex: 3
    end
	 	it "renders the showbyday template" do
    		expect(response).to render_template :showbyday
   	end
   	it "assigns requested day performances" do
   		expect(assigns(:performances)).to match_array(@performances)
   	end
	end
	context "select by day" do
		it " returns a zero dayindex when no valid festival" do
			get :showbyday, dayindex: 2
			expect(assigns(:dayindex)).to eq 0
		end
		context "valid day index" do
			before(:each) do
				performance = create(:performance_with_just_festival)
    		@performances = [performance]
			end				

			it "returns parameter dayindex" do
    		get :showbyday, dayindex: 2
				expect(assigns(:dayindex)).to eq 2
			end
		end	
	end
	context 'number of festival days' do
		it "assigns 0 to days when no festival records" do
			get :showbyday, dayindex: 2
			expect(assigns(:days)).to eq 0
		end
		it "assigns 0 to days when no current festival" do
			festival = create(:festival_inactive)
			get :showbyday, dayindex: 2
			expect(assigns(:days)).to eq 0
		end
		it "assigns festival.days to days for current festival" do
			festival = create(:festival)
			get :showbyday, dayindex: 3
			expect(assigns(:days)).to eq festival.days
		end
	end
	context "select by day number" do
		before (:each) do
			@p = create(:performance_with_festival)
  		@performances = [@p]
		end			
		it "returns empty when no performances match day number" do
  		get :showbyday, dayindex: 2
  		expect(assigns(:performances)).to be_empty
    end
		it "assigns matching day performance" do
  		get :showbyday, dayindex: 3
  		expect(assigns(:performances)).to match_array(@performances)
    end
    it "does not select other day performances" do
    	performance = create(:performance, daynumber: 2, stage_id: @p.stage_id, festival_id: @p.festival_id)
  		get :showbyday, dayindex: 2
  		expect(assigns(:performances)).to match_array(performance)
  	end
  end
  context "sort order" do
    it "assigns by startime ascending" do	
			performance2 = create(:performance_with_festival)
  		performance1 = create(:performance, starttime: "9:16", stage_id: performance2.stage_id, festival_id: performance2.festival_id)
  		performance3 = create(:performance, starttime: "20:00", stage_id: performance2.stage_id, festival_id: performance2.festival_id)
    	performances = [performance1,performance2,performance3]
  		get :showbyday, dayindex: 3
  		expect(assigns(:performances)).to eq performances
    end
	end
	context "artist" do
		it "has an artist for each peformance" do
			f = create(:festival_with_stages_and_performances, stage_count: 1 )
			p = Performance.first
			artist = p.artist
			get :showbyday, dayindex: 1
			expect(assigns(:performances)[0].artist).to eq artist
		end
	end
	context "stages" do
		it "has empty stages when no current festival" do
			get :showbyday, dayindex: 1
			expect(assigns(:stages) ).to be_empty 
		end
		it "assigns stages" do
			festival = create(:festival_with_stages)
			stages = Stage.all
			get :showbyday, dayindex: 1
			expect(assigns(:stages) ).to match_array stages
		end			
		it "assigns stages in sequence" do
			festival = create(:festival_with_stages_random_order)
			get :showbyday, dayindex: 1
			(0..4).each do |index|
				expect(assigns(:stages)[index].seq).to eq index + 1
			end
		end
	end
	context "header" do
		it "assigns a peformance date" do
			festival = create(:festival, startdate: '2016-3-25')
			get :showbyday, dayindex: 2
			expect(assigns(:performancedate)).to eq "( Sat 26 March 2016 )"
		end
	end
end
