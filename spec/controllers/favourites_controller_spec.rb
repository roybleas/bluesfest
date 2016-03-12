# == Schema Information
#
# Table name: favourites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  artist_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe FavouritesController, :type => :controller do
	context "confirm user login " do
		context "without being logged in" do
			it "redirects add " do
		   	get :add, letter: 'a'
		   	expect(response).to redirect_to (login_url)
		   end
			it "redirects index" do
		   	get :index
		   	expect(response).to redirect_to (login_url)
		  end
			it "redirects day" do
		   	get :day, dayindex: 1
		   	expect(response).to redirect_to (login_url)
		   end
		   it "has redirect for destroy" do
		      delete :destroy, id: 1
		      expect(response).to redirect_to (login_url)
		   end
		   it "has redirect for create" do
		      post :create, id: 1
		      expect(response).to redirect_to (login_url)
		   end

		end
		context "with user logged in it response" do
			before(:example) do
				user = create(:user)
				session[:user_id] = user.id
			end	  	
	    it "has success for index" do
	      get :index
	      expect(response).to have_http_status(:success)
	    end
	    context "with return address" do
	    	before(:example) do
	    		request.env["HTTP_REFERER"] = "where_i_came_from"
	    	end
		    it "has redirect for destroy" do
		      delete :destroy, id: 1
		      expect(response).to have_http_status(:redirect)
		    end
		   	it "has redirect for create" do
		   		artist = create(:artist)
		      post :create, id: artist.id
		      expect(response).to have_http_status(:redirect)
		    end
			end
	    it "has success for add" do
	  		festival = create(:festival)
	      get :add, letter: 'a'
	      expect(response).to have_http_status(:success)
	    end
	    it "has success for day" do
	    	festival = create(:festival)
	      get :day, dayindex: 1
	      expect(response).to have_http_status(:success)
	    end
		end
	end
	describe "GET index" do
		context "with one favourite" do
			before(:example) do
		  	@logged_in_user = create(:user_for_favourite)
		   	session[:user_id] = @logged_in_user.id
			end			
			it "returns a list of favourites for user" do
		   	other_user = create(:user_for_favourite)
		   	favourites = Favourite.for_user(@logged_in_user).all
		   	get :index
		   	expect(assigns(:favourites)[0].user.id).to eq (@logged_in_user.id)
		  end
		  it "returns favourites that include artist" do
		   	get :index
		   	expect(assigns(:favourites)[0].artist).to be_valid
	   	end
	  end
		it "returns a sorted list of artists" do
			user = create(:user_for_favourites_with_desc_artist_list_name, artist_count: 3)
	   	session[:user_id] = user.id
	   	get :index
	   	expect(assigns(:favourites)[0].artist.name).to eq("1 - artist")
	  end
		it "returns an empty array when only other users have favourites" do
			user = create(:user_for_favourites_with_desc_artist_list_name, artist_count: 3)
			user_without_favourites = create(:user)
			session[:user_id] = user_without_favourites.id
	   	get :index
	   	expect(assigns(:favourites)).to be_empty
	  end
	  
		it "returns number of festival days" do
			user = create(:user)
			session[:user_id] = user.id
			festival = create(:festival)
			get :index
			expect(assigns(:festivaldays)).to eq(festival.days)
		end
		it "returns nil number of festival days when no current festival" do
			user = create(:user)
			session[:user_id] = user.id
			festival = create(:festival, active: false)
			get :index
			expect(assigns(:festivaldays)).to be_nil
		end
	end
	describe "Get add" do
		before(:example) do
	  	@logged_in_user = create(:user)
	   	session[:user_id] = @logged_in_user.id
		end			
		it "returns empty artist list when no artists exist" do
			festival = create(:festival)
			get :add, letter: 'a'
	    expect(assigns(:artists)).to be_empty
	  end
		context "with artist pages" do
			before(:example) do
				@festival = create(:festival_with_artist_pages)
			end
			it "assigns the page to the requested page range" do
				get :add, letter: "a"
				expect(assigns(:page).title).to eq "A-B"
			end
			it "assigns a list of artist pages" do
				get :add, letter: "c"
				expect(assigns(:pages)).to match_array(Artistpage.all.to_a)
			end
			it "assigns the first page if not found " do
				get :add, letter: "z"
				expect(assigns(:page).title).to eq "Tn-Z"
			end
		end
		context "artist list" do
			before(:example) do
				@festival = create(:festival_with_artist_pages, page_count: 1)
    	end
			it "returns artist begining with a" do
				artist = create(:artist, name: "Archie Roach",festival_id: @festival.id, active: true)
				get :add, letter: 'a'
				expect(assigns(:artists)).to match_array(artist)
			end
			it "does not return artist begining with t" do
				artist = create(:artist,festival_id: @festival.id, active: true)
				get :add, letter: 'a'
				expect(assigns(:artists)).to_not match_array(artist)
			end
			it "returns artists linked to favourites but no favourites created " do
				artist = create(:artist, name: "Archie Roach",festival_id: @festival.id, active: true)
				get :add, letter: 'a'
				expect(assigns(:artists)[0].fav_user_id).to be_nil
			end
			it "returns artists linked to favourites and selected by user" do
				artist = create(:artist, name: "Archie Roach",festival_id: @festival.id, active: true)
				favourite = create(:favourite,user_id: @logged_in_user.id, artist_id: artist.id)
				get :add, letter: 'a'
				expect(assigns(:artists)[0].fav_user_id).to eq(@logged_in_user.id)
			end
			it "returns artists linked to favourites and selected by different user" do
				artist = create(:artist, name: "Archie Roach",festival_id: @festival.id, active: true)
				other_user = create(:user_in_sequence)
				favourite = create(:favourite,user_id: @logged_in_user.id, artist_id: artist.id)
				puts 
				get :add, letter: 'a'
				expect(assigns(:artists)).to include artist
			end
		end

	end
	describe "GET day" do
		context "Missing active festival" do
			it "returns nil number of festival days when no current festival" do
				user = create(:user)
				session[:user_id] = user.id
				festival = create(:festival, active: false)
				get :day, dayindex: 2
				expect(assigns(:festivaldays)).to eq 0
				expect(assigns(:performancedate)).to eq ""
				expect(assigns(:performances)).to be_empty
			end
		end
		context "has an active festival" do
			before(:example) do
				@logged_in_user = create(:user)
				session[:user_id] = @logged_in_user.id
				@festival = create(:festival)
			end
			it "returns number of festival days" do
				get :day, dayindex: 2
				expect(assigns(:festivaldays)).to eq(@festival.days)
			end
			it "returns the day index" do
				get :day, dayindex: 2
				expect(assigns(:dayindex)).to eq(2)
			end
			it "returns last festival day as dayindex if outside festival range" do
				get :day, dayindex: 6
				expect(assigns(:dayindex)).to eq(5)
			end
			it "returns formatted performance date" do
			 get :day, dayindex: 2
			 expect(assigns(:performancedate)).to eq "( Fri 25 March 2016 )"
			end
		end
	end
	describe "POST favourite" do
		before(:example) do
			@logged_in_user = create(:user)
			session[:user_id] = @logged_in_user.id
			@festival = create(:festival_with_stage_artist_performance)
			@artist = Artist.first
			request.env["HTTP_REFERER"] = "where_i_came_from"
		end
		it "saves  a favourite" do
			expect{ post :create, id: @artist.id}.to change(Favourite,:count).by(1)
		end			
		it "saves favourite performances linked to favourite" do
			expect{ post :create, id: @artist.id}.to change(Favouriteperformance,:count).by(1)
		end
		it "saves multiple favourite performances linked to favourite" do
			festival = create(:festival_with_stage_artist_multiple_performances, performance_count: 5 )
			artist = Artist.where(festival_id: festival.id).first
			expect{ post :create, id: artist.id}.to change(Favouriteperformance,:count).by(5)
		end
		it "rejects duplicate favourites" do
			expect{ post :create, id: @artist.id}.to change(Favourite,:count).by(1)
			expect{ post :create, id: @artist.id}.to change(Favourite,:count).by(0)
		end
		it "does not create favouriteperformances when duplicate favourites" do
			festival = create(:festival_with_stage_artist_multiple_performances, performance_count: 5 )
			artist = Artist.where(festival_id: festival.id).first
			expect{ post :create, id: artist.id}.to change(Favouriteperformance,:count).by(5)
			expect{ post :create, id: artist.id}.to change(Favouriteperformance,:count).by(0)
		end
	end
	describe "DELETE favourite" do
		before(:example) do
			@logged_in_user = create(:user_for_favourites_with_desc_artist_list_name, artist_count:  1)
			session[:user_id] = @logged_in_user.id
			request.env["HTTP_REFERER"] = "where_i_came_from"
		end
		it "deletes a favourite" do
			favourite = Favourite.where(user_id: @logged_in_user.id).take
			expect{ delete :destroy, id: favourite.id}.to change(Favourite,:count).by(-1)
		end
		it "has error message when favourite not found" do
			delete :destroy, id: -1
			expect(flash[:error]).to be_present 
		end
		it "deletes favourite perfomances as well as favourite" do
			user = create(:user_for_favourites_with_performances)
			favourite = Favourite.find_by_user_id(user.id)
			session[:user_id] = user.id
			expect{ delete :destroy, id: favourite.id}.to change(Favouriteperformance,:count).by(-3)
		end
	end
end
