require 'rails_helper'

RSpec.describe ArtistsHelper, :type => :helper do
	describe "link_to_artist_artistpage" do
		before(:example) do
			@artist = build(:artist)
		end
		it "returns link to artists page with letter" do
			expect(link_to_artist_artistpage(@artist)).to include("artists/bypage/t")
		end
		
		# cannot find how to set up request.env["HTTP_REFERER"] outside of controller specs
		# so cannot test for the moment	
				
		#request.env["HTTP_REFERER"] = "favourites/add/t"
			
		#	it "returns link to favourites add page with letter when called from there" do
		#		expect(link_to_artist_artistpage(@artist)).to include("favourites/add/t")
		#	end 
	
	end
  describe "add_or_remove" do
  	it "returns add when favourite does not exist" do
  		favourite = nil
  		artist = create(:artist)
  		expect(add_or_remove(favourite, artist)).to include("Add")
      expect(add_or_remove(favourite, artist)).to include("favourites?id=#{artist.id}")
      expect(add_or_remove(favourite, artist)).to include("post")
  	end
  end
 	it "returns remove when favourite exists and passed as Favourite active record" do
		artist = create(:artist)
		favourite = create(:favourite, artist_id: artist.id)
		expect(add_or_remove(favourite, artist)).to include("Remove")
		expect(add_or_remove(favourite, artist)).to include("favourites/#{favourite.id}")
		expect(add_or_remove(favourite, artist)).to include("delete")
	end
	it "returns remove when favourite exists and passed as integer" do
		artist = create(:artist)
		favourite = create(:favourite, artist_id: artist.id)
		expect(add_or_remove(favourite.id, artist)).to include("Remove")
		expect(add_or_remove(favourite.id, artist)).to include("favourites/#{favourite.id}")
		expect(add_or_remove(favourite.id, artist)).to include("delete")
	end

	describe "favourites_link_or_icon" do
		context "icon" do
			before(:example) do
				@favourites_style = :as_glypicon
				@artist = create(:artist)
			end
			it "returns a blank when icon and nil" do
				favourite = nil
				expect(favourites_link_or_icon(@favourites_style,favourite,@artist)).to be_empty
			end
			it "returns an icon when icon with an id" do
				favourite = 2345
				expect(favourites_link_or_icon(@favourites_style,favourite,@artist)).to include('<span class="glyphicon glyphicon-music"></span>')
			end
		end
		context "link" do
			before(:example) do
				@favourites_style = :as_link
				@artist = create(:artist)
			end
			it "returns Add when link and a nil" do
				favourite = nil
				expect(favourites_link_or_icon(@favourites_style,favourite,@artist)).to include("Add")
			end
			it "returns Remove when link and and an id" do
				favourite = create(:favourite, artist_id: @artist.id)
				expect(favourites_link_or_icon(@favourites_style,favourite,@artist)).to include("Remove")
			end	
		end
		it "returns an error note for style when invalid style passed" do
			favourites_style = "invalid_style"
			favourite = nil
			@artist = create(:artist)
			expect(favourites_link_or_icon(favourites_style,favourite,@artist)).to include("Invalid Favourites Style[#{favourites_style}]")
		end
	end
	describe "link_to_favourites_or_artists" do
		it "returns artist path when style is for artists page" do
			expect(link_to_favourites_or_artists(:page_artists, "j")).to eq "/artists/bypage/j"
		end
		it "returns favourites path when style is for favourites page" do
			expect(link_to_favourites_or_artists(:page_favourites, "j")).to eq "/favourites/add/j"
		end

	end
end
