require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ArtistsHelper. For example:
#
# describe ArtistsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ArtistsHelper, :type => :helper do
  describe "add_or_remove" do
  	it "returns add when favourite does not exist" do
  		favourite = nil
  		artist = create(:artist)
  		expect(add_or_remove(favourite, artist)).to include("Add")
      expect(add_or_remove(favourite, artist)).to include("favourites?id=#{artist.id}")
      expect(add_or_remove(favourite, artist)).to include("post")
  	end
  end
 	it "returns remove when favourite exists" do
		
		artist = create(:artist)
		favourite = create(:favourite, artist_id: artist.id)
		expect(add_or_remove(favourite,artist)).to include("Remove")
		expect(add_or_remove(favourite, artist)).to include("favourites/#{favourite.id}")
		expect(add_or_remove(favourite, artist)).to include("delete")
	end

end
