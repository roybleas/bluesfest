require 'rails_helper'

RSpec.describe "favourites/add.html.erb", :type => :view do
	
  context "style for favourites.bypage" do
  	before(:example) do
  		assign(:favourites_style, :as_link)
  		@artist = create(:artist)
  	end
  	it "shows a link to Favourites in title" do
  		assign(:artists,[])
  		render
  		assert_select "a[href=?]","/favourites"
  	end
	  it "shows Add link when not linked to favourite artist " do
	 		favourite = nil
	 		artist = Artist.select("artists.*,null as fav_id").take
	  	artists = [artist]
	  	assign(:artists,artists)
	  	render
	  	assert_select "a[href=?]", "/favourites?id=#{@artist.id}" 
			assert_select "a[data-method=?]", "post"
	  end
	  it "shows Remove link when linked to artist" do
	 		favourite = create(:favourite, artist_id: @artist.id)
	 		artist = Artist.select("artists.*,#{favourite.id} as fav_id").take
	  	artists = [artist]
	  	assign(:artists,artists)
	  	render
  		assert_select "a[href=?]", "/favourites/#{favourite.id}" 
			assert_select "a[data-method=?]", "delete"
	  end
	end
	describe "delete all user favourites" do
		it "shows a delete link " do
  		artist = create(:artist)
  		favourite = create(:favourite, artist_id: artist.id)
  		artist = Artist.select("artists.*,#{favourite.id} as fav_id").take
	  	artists = [artist]
	  	assign(:artists,artists)
	  	render
  		assert_select "a[href=?]", "/favourites/clearall" 
			assert_select "a[data-method=?]", "delete"
			assert_select "a" , "Clear" 
			expect(rendered).to include "all artists from favourites list"
		end			
	end
	describe "shows badge with a count of favourites" do
		it "shows a badge with current total of favourites" do
			artist = create(:artist)
	 		favourite = nil
	 		artist = Artist.select("artists.*,null as fav_id").take
	  	artists = [artist]
	  	assign(:artists,artists)
	  	assign(:favouritescount,6)
	  	render
			assert_select "span.badge", {:text => "6", :count => 1}
		end
	end
end
