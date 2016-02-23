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
  			dayofweek = startdate.strftime("%a %d %b") 
  		end
		end
	end
end
	