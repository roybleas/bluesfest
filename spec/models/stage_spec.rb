# == Schema Information
#
# Table name: stages
#
#  id          :integer          not null, primary key
#  title       :string
#  code        :string(2)
#  seq         :integer
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Stage, :type => :model do
  it "is valid with a title, code seq number and festival id" do
		stage = Stage.new(
			title: 'Mojo',
			code: 'mo',
			seq: 1,
			festival_id: 1)
			expect(stage).to be_valid
	end
end
