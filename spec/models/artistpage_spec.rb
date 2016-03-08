# == Schema Information
#
# Table name: artistpages
#
#  id          :integer          not null, primary key
#  letterstart :string
#  letterend   :string
#  title       :string
#  seq         :integer
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Artistpage, :type => :model do
  it "has a start letter, end letter, title, and sequence" do
  	artistpage = Artistpage.new(
  		letterstart: "a",
  		letterend:   "b",
  		title:       "A-B",
  		seq:          2,
  		festival_id:  1)
  	expect(artistpage).to be_valid
  end
end
