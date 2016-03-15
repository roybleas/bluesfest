# == Schema Information
#
# Table name: favouriteperformances
#
#  id             :integer          not null, primary key
#  performance_id :integer
#  active         :boolean          default(TRUE)
#  favourite_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Favouriteperformance, :type => :model do
    it "creates record" do
  	favouriteperformance = build(:favouriteperformance )
  	expect(favouriteperformance).to be_valid
  end
  it "has foriegn keys to artist" do
  	fp = create(:favourite_for_favouriteperformance)
  	favouriteperformance = Favouriteperformance.includes(:favourite).first
  	expect(favouriteperformance).to be_valid
	end
end
