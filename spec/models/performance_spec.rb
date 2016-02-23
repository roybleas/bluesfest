# == Schema Information
#
# Table name: performances
#
#  id              :integer          not null, primary key
#  daynumber       :integer
#  duration        :string
#  starttime       :time
#  scheduleversion :string
#  festival_id     :integer
#  artist_id       :integer
#  stage_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Performance, :type => :model do
   it "creates record" do
  	performance = build(:performance )
  	expect(performance).to be_valid
  end
  it "has foriegn keys to festival,artist and stage" do
  	f = create(:performance_with_festival)
  	performance = Performance.includes(:artist, :stage, :festival).first
  	expect(performance.artist).to be_valid
  	expect(performance.stage).to be_valid
  	expect(performance.festival).to be_valid
	end
end
