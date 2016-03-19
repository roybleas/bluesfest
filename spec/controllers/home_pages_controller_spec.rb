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
		it "redirects to now for today and not logged in" do
			travel_to(@festival.startdate)
			get :home
			expect(subject).to redirect_to now_path
		end
		it "renders plan when today and loged in" do
			@logged_in_user = create(:user)
			session["user_id"] = @logged_in_user
			get :home
			expect(subject).to render_template(:plan)
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
	
		context "logged in" do
			before(:example) do
				@logged_in_user = create(:user)
				session["user_id"] = @logged_in_user.id
			end
			it "has dayindex of one when startdate = today" do
				travel_to(@festival.startdate)
				get :home
				expect(assigns(:dayindex)).to eq 1
			end
			it "has dayindex of 3 when 2 days after start day" do
				travel_to(@festival.startdate + 2)
				get :home
				expect(assigns(:dayindex)).to eq 3
			end

			it "has no personal schedule" do
				travel_to(@festival.startdate)
				get :home
				expect(assigns(:performances)).to be_empty
			end
			it "has a personal schedule" do
				user = create(:user_for_favourites_with_performances_and_stage)
				session["user_id"] = user.id
				p = Performance.first
				get :home
				expect(assigns(:performances)).to match_array([p])				
			end
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
