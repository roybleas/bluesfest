require 'rails_helper'

RSpec.describe "artists/index.html.erb", :type => :view do
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
  	artist = create(:artist)
  	artists = [artist]
  	assign(:artists,artists)
  	render
  	expect(rendered).to match /#{artist.name}/
  end
  it "shows a link to artist web page" do
  	artist = create(:artist,code: "755")
  	artists = [artist]
  	assign(:artists,artists)
  	render
  	expect(rendered).to match /http:\/\/www.bluesfest.com.au\/schedule\/detail.aspx\?ArtistID=755/
  end
  it "shows back to top link" do
  	artist = create(:artist)
  	artists = Array.new(20) { |a| a = artist}
  	assign(:artists,artists)
  	render
  	expect(rendered).to match /Back to Top/
  end 
  it "does not shows back to top link" do
  	artist = create(:artist)
  	artists = Array.new(19) { |a| a = artist}
  	assign(:artists,artists)
  	render
  	expect(rendered).to_not match /Back to Top/
  end 
end
