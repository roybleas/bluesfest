module Validations
	extend ActiveSupport::Concern
	
	def valid_dayindex(festival,index)
		index = index.to_i
	  if festival.nil?
  		dayindex = 0 
  	else
  		dayindex = index > festival.days ? festival.days : index
  		dayindex = 1 if index < 1
  	end
		return dayindex
	end
	
	def valid_dayofweek(festival,index)
		index = index.to_i
	  dayofweek = nil
	  if !festival.nil?
		  if !festival.startdate.nil?
  			startdate = festival.startdate + (index - 1)
  			dayofweek = startdate.strftime("%a") 
  		end
		end
	end
	
	def previous_dayindex(festival,index)
		index = index.to_i
  	if festival.nil?
  		dayindex = nil
  	else
  		if (index > festival.days) || index < 1
  			dayindex = 1
  		else 
  			dayindex = index == 1 ? festival.days : index - 1
  		end
		end
		return dayindex
	end
	def next_dayindex(festival,index)
		index = index.to_i
  	if festival.nil?
  		dayindex = nil
  	else
  		if (index > festival.days) || index < 1
  			dayindex = festival.days
  		else 
  			dayindex = index == festival.days ? 1 : index + 1
  		end
		end
		return dayindex
	end
	
	def previous_stage(stages,current_stage)
		if stages.nil? || current_stage.nil?
			return nil
		else
			
			if stages.first.id == current_stage.id 
				previous = stages.last
			else
				previous = stages.first
				stages.each do |stage| 
					if stage.id == current_stage.id
						break
					else
						previous = stage
					end
				end
			end
		end
		return previous
	end
	
	def next_stage(stages,current_stage)
		if stages.nil? || current_stage.nil?
			return nil
		else
			
			if stages.last.id == current_stage.id 
				stage_next = stages.first
			else
				stage_next = stages.last
				stages.reverse_each do |stage| 
					if stage.id == current_stage.id
						break
					else
						stage_next = stage
					end
				end
			end
		end
		return stage_next
	end

end
	