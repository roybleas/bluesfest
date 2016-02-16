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

class Stage < ActiveRecord::Base
  belongs_to :festival
  
 	def self.current_active_festival
		joins(:festival).where('festivals.active = true')
	end
	def self.by_code_and_festival_id(stage_code,festival_id)
		where("stages.code = ? and stages.festival_id = ?",stage_code,festival_id)
	end


end
