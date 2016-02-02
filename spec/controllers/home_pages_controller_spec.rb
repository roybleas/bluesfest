require 'rails_helper'
require 'date'

RSpec.describe HomePagesController, :type => :controller do

    describe "GET home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end
	context "current festival" do
		it "returns the active festival" do
			festival = create(:festival)
			get :home
			expect(assigns(:festival)).to eq festival
		end
		it "return nil when no active festival" do
			festival = create(:festival, active: false)
			get :home
			expect(assigns(:festival)).to be_nil
		end
		it "returns active festival record  when mutiple festival records" do
			festival = create(:festival, active: false, year: '2015')
			festival = create(:festival, active: true, year: '2017')
			get :home
			expect(assigns(:festival).year).to eq('2017')
		end
		it "returns most recent active festival startdate record  when mutiple active festival records" do
			festival = create(:festival, active: true, startdate: '2016-4-2')
			festival = create(:festival, active: true, startdate: '2016-4-3')
			get :home
			expect(assigns(:festival).startdate).to eq(Date.parse('2016-4-3'))
		end

	end
	context "days to go" do
		include ActiveSupport::Testing::TimeHelpers
		before (:each) do
			@festival = create(:festival)
		end
		it "redirects to plan for tody " do
			travel_to(@festival.startdate)
			get :home
			expect(response).to redirect_to plan4today_url
		end
		it "returns start tomorrow" do
			test_date = @festival.startdate.prev_day(1)
			travel_to(test_date)
			get :home
			expect(assigns(:days2go)).to eq("Starts tomorrow!!")
		end
		it "returns 2 days before festival" do
			test_date = @festival.startdate.prev_day(2)
			travel_to(test_date)
			get :home
			expect(assigns(:days2go)).to eq("Only 2 days to go!")
		end
		it "returns 2 weeks before festival" do
			test_date = @festival.startdate.prev_day(14)
			travel_to(test_date)
			get :home
			expect(assigns(:days2go)).to eq("Only 14 days to go!")
		end
		it "festival over after festival" do
			test_date = @festival.startdate.next_day(6)
			travel_to(test_date)
			get :home
			expect(assigns(:days2go)).to eq("It's over for this year see you next year")
		end
		it "returns blank string when no current festival" do
			@festival.update(active: false)
			get :home
			expect(assigns(:days2go)).to eq("")
		end
	end

  describe "GET plan" do
    it "returns http success" do
      get :plan
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET now" do
    it "returns http success" do
      get :now
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET next" do
    it "returns http success" do
      get :next
      expect(response).to have_http_status(:success)
    end
  end

end
