# == Schema Information
#
# Table name: favourites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  artist_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module FavouritesHelper
	
	def preceding_day_cells(dayindex,favperform)
		cell_count = 0
		cell_count = (favperform.performance.daynumber - dayindex)
		return ("<td colspan='2'></td>" * cell_count).html_safe unless cell_count < 0 
	end
	
	def following_day_cells(dayindex,festivaldays)
		cell_count = 0
		cell_count = (festivaldays - dayindex)
		return ("<td colspan='2'></td>" * cell_count).html_safe unless cell_count < 0 
	end

	def fav_perform_tick_link(favperform)
		
		this_link_id = "#{favperform.id}_td"
		this_span_id = "#{favperform.id}_span"
		
		if favperform.active == true 
			this_class = "btn btn-primary btn-xs"
			this_glyphicon = "ok"
		else
			this_class = "btn btn-warning btn-xs"
			this_glyphicon = "remove"
		end
		
		this_span = "<span id='#{this_span_id}' class='glyphicon glyphicon-#{this_glyphicon}'></span>".html_safe
		
		return link_to this_span, favperformupdate_path(:id => favperform.id), :method => :patch, id: this_link_id , class: this_class, "role" => "button", :remote => true 				
	end	
	
	def is_day_button_current_index(day, dayindex)
		return "btn btn-info btn-sm" unless day == dayindex
		return "btn btn-primary btn-sm" 
	end
end
