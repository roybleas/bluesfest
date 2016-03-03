module PerformancesHelper
	def outstanding_stage_cells(stage_index,stage_count)
		cell_count = (stage_count - stage_index)
		return ("<td></td>" * cell_count).html_safe unless cell_count < 0
	end
	
	def preceding_stage_cells(stage_index,next_index)
		cell_count = (next_index - stage_index)
		return ("<td></td>" * cell_count).html_safe unless cell_count < 0 
	end
	
	def find_matching_stage_index(stage_index,stage_count,performance,stages)
		default_index = nil
		(stage_index...stage_count).each do |index|
			if stages[index].id == performance.stage_id
				return index
			end
		end
		return default_index
	end
		
	
end
