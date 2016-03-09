# == Schema Information
#
# Table name: performances
#
#  id              :integer          not null, primary key
#  daynumber       :integer
#  duration        :string
#  starttime       :time
#  title           :string
#  scheduleversion :string
#  festival_id     :integer
#  artist_id       :integer
#  stage_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module PerformancesHelper
	def outstanding_stage_cells(stage_index,stage_count)
		cell_count = (stage_count - stage_index)
		return ("<td></td>" * cell_count).html_safe unless cell_count < 0
	end
	
	def preceding_stage_cells(stage_index,next_index)
		cell_count = 0
		cell_count = (next_index - stage_index) unless stage_index.nil? || next_index.nil?
		return ("<td></td>" * cell_count).html_safe unless cell_count < 0 
	end
	
	def find_matching_stage_index(stage_index,stage_count,performance,stages)
		default_index = nil
		(stage_index...stage_count).each do |index|
			if stages[index].id == performance.stage_id
				return index
			end
		end
		logger.debug "#{stage_index},#{stage_count},#{performance.inspect},#{stages.inspect}"
		return default_index
	end
		
	
end
