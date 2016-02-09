# == Schema Information
#
# Table name: artists
#
#  id          :integer          not null, primary key
#  name        :string
#  code        :string
#  active      :boolean
#  extractdate :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Artist, :type => :model do
  it "is invalid without a name" do
  	artist = build(:artist , name: nil)
  	artist.valid?
  	expect(artist.errors[:name]).to include("can't be blank")
  end

  it "has one festival record" do
  	artist = build(:artist )
  	expect(artist).to be_valid
  end
	
	it "has a default active value of false" do
		artist = Artist.create(name: "fred")
		expect(artist.active).to_not be_nil
	end
end
