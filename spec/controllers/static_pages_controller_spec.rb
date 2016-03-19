require 'rails_helper'

RSpec.describe StaticPagesController, :type => :controller do
	
   describe "GET about" do
    it "returns http success" do
      get :about
      expect(response).to have_http_status(:success)
    end
    context "no active festival" do
	    it "returns unknown version when no active festival" do
				get :about
				expect(assigns(:version)).to eq "Unknown"
			end
			it "returns unknown schedule date when no active festival" do
				get :about
				expect(assigns(:scheduledate)).to eq "Unknown"
			end
		end
		context "has an active festival" do
			before :each do
				create(:festival, major: 2, minor: 1, scheduledate: "2016-4-5")
			end
			
	    it "returns version from current active festival" do
				get :about
				expect(assigns(:version)).to eq "2.1"
			end
	    it "returns schedule date from current active festival" do
				get :about
				expect(assigns(:scheduledate)).to eq "05 April 2016"
			end

		end		
  end
  
  describe "Get Help" do
    it "returns http success" do
      get :help
      expect(response).to have_http_status(:success)
  	end
  end

end
