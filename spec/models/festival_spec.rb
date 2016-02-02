# == Schema Information
#
# Table name: festivals
#
#  id           :integer          not null, primary key
#  startdate    :date
#  days         :integer
#  scheduledate :date
#  year         :string
#  title        :string
#  major        :integer
#  minor        :integer
#  active       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Festival, :type => :model do
  it "can be created with Factory Girl" do
  	festival = FactoryGirl.build(:festival)
  	expect(festival).to be_valid
  end
  
end
