require 'rails_helper'

RSpec.describe TestpagesController, :type => :controller do

  describe "GET settime" do
    it "returns http success" do
      get :settime, day: 1, hr: 18, min: 15
      expect(response).to have_http_status(:success)
    end
		context "verify parameters" do
			context "with a festival" do
				it "and the festival is not set " do
					get :settime, day: 1, hr: 18, min: 15
					expect(flash[:warning]).to match /No current active festival/ 
				end
				it "set " do
					festival = create(:festival)
					get :settime, day: 1, hr: 18, min: 15
					expect(flash[:warning]).to_not match /No current active festival/ 
				end				
			end
			context "has a day set outside festival days range" do
				before(:example) do
					festival = create(:festival)
				end
				it "returns 0 dayindex" do
					
					get :settime, day: 0, hr: 18, min: 15
					expect(assigns(:dayindex)).to eq 0
					
				end
				it "returns 6 dayindex" do
					get :settime, day: 6, hr: 18, min: 15
					expect(assigns(:dayindex)).to eq 0
					expect(flash[:warning]).to match /Invalid day value - Festival days is 5/ 
				end
			end
			context "has a day set within festival days range" do
				before(:example) do
					festival = create(:festival)
				end
				it "returns 1 for day index" do
					get :settime, day: 1, hr: 18, min: 15
					expect(assigns(:dayindex)).to eq 1
				end					
				it "returns 5 for day index" do
					get :settime, day: 5, hr: 18, min: 15
					expect(assigns(:dayindex)).to eq 5
				end					
			end
			context "when an invalid hour value" do
				before(:example) do
					festival = create(:festival)
				end
				it "has a warning message" do
					get :settime, day: 1, hr: 24, min: 15
					expect(assigns(:hr)).to eq 0
					expect(flash[:warning]).to match /Invalid hour value/ 
				end
			end
			context "when hour value is valid" do
				before(:example) do
					festival = create(:festival)
				end
				it "returns max input hour" do
					get :settime, day: 1, hr: 23, min: 15
					expect(assigns(:hr)).to eq 23
					expect(flash[:warning]).to_not match /Invalid hour value/ 
				end
				it "returns min input hour" do
					get :settime, day: 1, hr: 0, min: 15
					expect(assigns(:hr)).to eq 0
					expect(flash[:warning]).to_not match /Invalid hour value/ 
				end
			end
			context "when an invalid minutes value" do
				before(:example) do
					festival = create(:festival)
				end
				it "has a warning message" do
					get :settime, day: 1, hr: 12, min: 60
					expect(assigns(:mins)).to eq 0
					expect(flash[:warning]).to match /Invalid minutes value/ 
				end
			end
			context "when minutes value is valid" do
				before(:example) do
					festival = create(:festival)
				end
				it "returns max input minutes" do
					get :settime, day: 1, hr: 23, min: 59
					expect(assigns(:mins)).to eq 59
					expect(flash[:warning]).to_not match /Invalid minutes value/ 
				end
				it "returns minimum input mins" do
					get :settime, day: 1, hr: 0, min: 0
					expect(assigns(:mins)).to eq 0
					expect(flash[:warning]).to_not match /Invalid minutes value/ 
				end
			end
		end
		context "create session value for test time" do
			before(:example) do
				@festival = create(:festival, startdate: "2016-3-21")
			end
			it "sets time value to 18:25 for day 2" do
				Time.zone ="Sydney"
				this_time = Time.new(2016,3,22,18,25)
				get :settime, day: 2, hr: 18, min: 25
				expect(session[:test_time]).to eq this_time
			end
			it "sets time value to 23.59 for day 5" do
				Time.zone ="Sydney"
				this_time = Time.new(2016,3,25,23,59)
				get :settime, day: 5, hr: 23, min: 59
				expect(session[:test_time]).to eq this_time
			end
			it "sets time value to 0:1 for day 1" do
				Time.zone ="Sydney"
				this_time = Time.new(2016,3,21,0,1)
				get :settime, day: 1, hr: 0, min: 1
				expect(session[:test_time]).to eq this_time
			end

		end		
  end

  describe "GET reset" do
    it "returns http success" do
      get :reset
      expect(response).to have_http_status(:success)
    end
    it "sets session to nil" do
    	session[:test_time] = Time.new(2016,3,21,17,15)
    	get :reset
    	expect(session[:test_time]).to be_nil
    end
  end
  describe "GET showtime" do
    it "returns http success" do
      get :showtime
      expect(response).to have_http_status(:success)
    end
    context "no test time set" do
    	it "has nil test time when session is not set" do
    		get :showtime
    		expect(assigns(:testtime)).to be_nil
    	end
    end
    context "test time set" do   	
    	it "has testime set to session time" do
    		test_time = Time.new(2016, 3, 31, 18,30)
    		testtime_caption = test_time.strftime("%a %d %b %Y %I:%M %p")
    		session[:test_time] = test_time
    		get :showtime
    		expect(assigns(:test_time)).to eq test_time
    		expect(assigns(:test_time_caption)).to eq testtime_caption
    	end
    end
    context "current time" do
    	it "returns the current localtime" do
    		Time.zone ="Sydney"
	    	get :showtime
	    	expect(assigns(:localTime_caption)).to eq Time.current.strftime("%a %d %b %Y %I:%M %p")
    	end
    end
  end

end
