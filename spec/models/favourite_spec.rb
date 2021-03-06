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

RSpec.describe Favourite, :type => :model do
  it "creates record" do
  	favourite = build(:favourite )
  	expect(favourite).to be_valid
  end
  it "has foriegn keys to artist" do
  	u = create(:user_for_favourite)
  	favourite = Favourite.includes(:artist, :user).first
  	expect(favourite.artist).to be_valid
  	expect(favourite.user).to be_valid
	end
end
