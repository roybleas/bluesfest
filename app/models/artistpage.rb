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

class Artistpage < ActiveRecord::Base
  belongs_to :festival

	def self.current_active_festival
		joins(:festival).where('festivals.active = true')
	end

	def self.by_letter(searchby)
		where("letterend >= :letter and letterstart <= :letter ",searchby)
	end
end
