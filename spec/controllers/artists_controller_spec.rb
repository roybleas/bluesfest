# == Schema Information
#
# Table name: artists
#
#  id          :integer          not null, primary key
#  name        :string
#  code        :string
#  linkid      :string
#  active      :boolean          default(FALSE)
#  extractdate :date
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe ArtistsController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    context "index of artists" do
    	before(:each) do
    		@artist = create(:artist_with_festival, active: true)
    		get :index
    	end
    	it "renders the index template" do
    		expect(response).to render_template :index
    	end
    	it "assigns all artists" do
    		expect(assigns(:artists)).to match_array(@artist)
    	end
    end
    context "active artists" do
    	before(:each) do
    		@festival = create(:festival) 
    		@artist = create(:artist, festival_id: @festival.id)
    	end
    	it "returns empty with no active artists" do
    		get :index
    		expect(assigns(:artists)).to be_empty
    	end
    	it "fetches the active artist" do
    		artist = create(:artist_with_festival, name: "active artist", active: true)
    		get :index
    		expect(assigns(:artists)).to match_array(artist)
    		expect(assigns(:artists)).to_not match_array(@artist)
    	end
    end
		context "active festival" do
			it "fetchs artist for active festival" do
				artist = create(:artist_with_festival)
				get :index
				expect(assigns(:artists)).to match_array(artist)
			end
			it "returns empty array for non active festival" do
				festival = create(:festival_inactive)
				artist = create(:artist, festival_id: festival.id, active: true)
				get :index
				expect(assigns(:artists)).to be_empty
			end
		end
  end

  describe "GET show" do
    context "show artist" do
    	before(:each) do
    		@artist = create(:artist_with_festival)
    		get :show, id: @artist
    	end
    	it "returns http success" do
      	get :show, id:@artist
      	expect(response).to have_http_status(:success)
    	end
    	it "renders the show template" do
    		expect(response).to render_template :show
    	end
    	it "assigns requested artist" do
    		expect(assigns(:artist)).to eq @artist
    	end
    end
    it "shows nil when no artist" do
    	expect(assigns(:artist)).to be_nil
    end

    context "performances"do
    	before(:each) do
    		performance = create(:performance_with_festival)
    		@performances = [performance]
    		@stage = Stage.first
    		@artist = Artist.first
			end    	
    	it "shows a performance" do
    		get :show, id: @artist
    		expect(assigns(:performances)).to match_array(@performances)
    	end
			it "shows a stage for a performance" do
				get :show, id: @artist
				expect(assigns(:performances)[0].stage.title).to eq @stage.title
			end
    end
    context "festival " do
    	it "shows startdate" do
    		artist = create(:artist_with_festival) 
    		festival = Festival.find(artist.festival_id)
    		get :show, id: artist
    		expect(assigns(:startdate_minus_one)).to eq festival.startdate - 1
    	end 
    	it "shows nil if no festival" do
    		artist = create(:artist) 
    		get :show, id: artist
    		expect(assigns(:startdate_minus_one)).to be_nil
    	end
    end
  end

end
