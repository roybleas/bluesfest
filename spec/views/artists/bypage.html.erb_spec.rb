require 'rails_helper'

RSpec.describe "artists/bypage.html.erb", :type => :view do
  it "shows heading" do
  	assign(:artists,[])
  	render
  	expect(rendered).to match /<h2>Artists<\/h2>/
  end
  it "shows no artists message when empty list" do
  	assign(:artists,[])
  	render
  	expect(rendered).to match /No artists added/
  end
  it "shows an artist " do
  	a = create(:artist)
  	artist = Artist.select("artists.*,null as fav_user_id").take
  	artists = [artist]
  	assign(:artists,artists)
  	render
  	expect(rendered).to match /#{artist.name}/
  end
  it "hide a music icon when not a favourite artist " do
  	a = create(:artist)
 		artist = Artist.select("artists.*,null as fav_user_id").take
  	artists = [artist]
  	assign(:artists,artists)
  	render
  	expect(rendered).to match /#{artist.name}/
  end
  it "shows a music icon when a favourite artist " do
  	a = create(:artist)
 		artist = Artist.select("artists.*,234 as fav_user_id").take
  	artists = [artist]
  	assign(:artists,artists)
  	render
  	expect(rendered).to match /#{artist.name}/
  end

  it "shows a link to artist web page" do
  	artist = create(:artist,linkid: "755")
  	artist = Artist.select("artists.*,null as fav_user_id").take
  	artists = [artist]
  	assign(:artists,artists)
  	render
  	expect(rendered).to match /http:\/\/www.bluesfest.com.au\/schedule\/detail.aspx\?ArtistID=755/
  end
  it "shows artist pagination" do
  	artist = create(:artist)
  	artist = Artist.select("artists.*,null as fav_user_id").take
  	artists = [artist]
  	assign(:artists,artists)
  	page = build(:artistpage)
  	pages = [page]
  	assign(:pages, pages)
  	render
  	expect(rendered).to match /A-B/
  end
  it "shows a link for artist page" do
  	artist = create(:artist)
  	artist = Artist.select("artists.*,null as fav_user_id").take
  	artists = [artist]
  	assign(:artists,artists)
  	page = build(:artistpage)
  	pages = [page]
  	assign(:pages, pages)
  	render
  	assert_select "a[href=?]", "/artists/bypage/a"
  end
  it "does not show artist pagination when no range" do
  	artist = create(:artist)
  	artist = Artist.select("artists.*,null as fav_user_id").take
  	artists = [artist]
  	assign(:pages, nil)
  	assign(:artists,artists)
  	render
  	expect(rendered).to_not match /A-B/
  end
  it "shows the passed page as the active page" do
  	artist = create(:artist)
  	artist = Artist.select("artists.*,null as fav_user_id").take
  	artists = [artist]
  	assign(:artists,artists)
  	page = create(:artistpage)
  	page2 = create(:artistpage, title: 'C-E')
  	page3 = create(:artistpage, title: 'F-J')
  	pages = [page,page2,page3]
  	assign(:pages, pages)
  	assign(:page, page)
  	render
  	assert_select "li.active", { count: 1} 
  end
  	
end
