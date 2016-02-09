require 'rails_helper'

RSpec.describe "artists/show.html.erb", :type => :view do
  it "shows artist name" do
  	artist = create(:artist)
  	assign(:artist, artist)
  	render
  	expect(rendered).to match /#{artist.name}/
  end
  it "shows missing artist" do
  	# assign(:artist, artist)
  	render
  	expect(rendered).to match /Unknown Artist/
  end
end
