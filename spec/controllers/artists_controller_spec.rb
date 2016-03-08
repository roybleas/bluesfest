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
      expect(response).to redirect_to artistsbypage_path('a')
    end
		xcontext "active festival" do
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
	
	describe "Get artistbypage" do
		context "index artists" do
			xit "returns http success" do
				get :bypage, letter: "y"
				expect(response).to have_http_success(:success )
			end
			it "renders bypage" do
				get :bypage, letter: "y"
				expect(response).to render_template :bypage
			end
		end
		context "select page range by letter" do
			before(:example) do
				@festival = create(:festival_with_artist_pages, page_count: 2)
			end
			it "assigns the page to the requested page range" do
				get :bypage, letter: "a"
				expect(assigns(:page).title).to eq "A-B"
			end
			it "assigns the first page if not found " do
				get :bypage, letter: ""
				expect(assigns(:page).title).to eq "A-B"
			end
			it "assigns the page ignoring case " do
				get :bypage, letter: "D"
				expect(assigns(:page).title).to eq "C-E"
			end
			it "assigns numbers to A " do
				get :bypage, letter: "2"
				expect(assigns(:page).title).to eq "A-B"
			end
		end
		context "full page range" do
			before(:example) do
				@festival = create(:festival_with_artist_pages )
			end
			it "assigns page when 2 letters in parameter" do
				get :bypage, letter: "Tn"
				expect(assigns(:page).title).to eq "Tn-Z"
			end
			it "assigns page when end edge " do
				get :bypage, letter: "Z"
				expect(assigns(:page).title).to eq "Tn-Z"
			end
			it "assigns page when end edge " do
				get :bypage, letter: "0"
				expect(assigns(:page).title).to eq "A-B"
			end
		end
		context "returns artists by page" do
			before(:example) do
				@festival = create(:festival_with_artist_pages, page_count: 1)
    	end
			it "returns artist begining with a" do
				artist = create(:artist, name: "Archie Roach",festival_id: @festival.id, active: true)
				get :bypage, letter: 'a'
				expect(assigns(:artists)).to match_array(artist)
			end
			it "does not return artist begining with t" do
				artist = create(:artist,festival_id: @festival.id, active: true)
				get :bypage, letter: 'a'
				expect(assigns(:artists)).to_not match_array(artist)
			end
			it "returns artist begining with  b" do
				artist = create(:artist, name: "Blind Boy Paxton",festival_id: @festival.id, active: true)
				get :bypage, letter: 'a'
				expect(assigns(:artists)).to match_array(artist)
			end
		end
		context "returns artists begining with 'z' by page  " do
			before(:example) do
				@festival = create(:festival_with_artist_pages)
    	end
			
			it "returns artist begining with z" do
				artist = create(:artist, name: "Zydeco Jump",festival_id: @festival.id, active: true)
				get :bypage, letter: 'z'
				expect(assigns(:artists)).to match_array(artist)
			end
		end
		context "non active " do
			before(:example) do
				@festival = create(:festival_with_artist_and_page)
			end
			it "festival returns empty" do
				@festival.update(active: false)
				get :bypage, letter:'a'
				expect(assigns(:artists)).to be_empty
			end
			it "artist returns empty array" do
				artist = Artist.current_active_festival.take
				artist.update(active:false)
				get :bypage, letter:'a'
				expect(assigns(:artists)).to be_empty
			end
		end
		context "artist pages" do
			it "returns all pages" do
				festival = create(:festival_with_artist_pages)
				get :bypage, letter:'a'
				expect(assigns(:pages)).to match_array(Artistpage.all.to_a)
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
