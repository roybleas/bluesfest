# == Schema Information
#
# Table name: artists
#
#  id          :integer          not null, primary key
#  name        :string
#  code        :string
#  linkid      :string
#  active      :boolean          default(FALSE)
#  extractdate :date
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module ArtistsHelper
	def is_active_page(current_page, active_page)
		if !active_page.nil? and !current_page.nil?
			if current_page.id == active_page.id
				return ('class="active"').html_safe
			end
		end
	end
	
	def link_to_artist_artistpage(artist)
		first_letter =  artist.nil? ? 'a' : artist.code.first
		return (link_to "Artists", artistsbypage_path(first_letter)).html_safe
		
	end
	
	def link_to_favourite_artist_artistpage(artist)
		first_letter =  artist.nil? ? 'a' : artist.code.first
		return (link_to "Artists", favadd_path(first_letter)).html_safe 
	end
	
	def add_or_remove(favourite,artist)
		if favourite.nil?
			return link_to "Add", favourites_path(:id => artist.id), :method => :post, class: "btn btn-info btn-xs", "role" => "button"
		else
			#depends if called with favourite or artist.fav_id
			favourite_id =  favourite.kind_of?(Favourite) ? favourite.id : favourite
			return link_to "Remove", favourite_path(:id => favourite_id), method: :delete,  class: "btn btn-danger btn-xs", "role" => "button"
		end
	end
	
	def add_or_remove_caption(favourite, artist)
		if favourite.nil?
			return " #{artist.name} to favourites. ".html_safe
		else
			return " #{artist.name} from favourites. ".html_safe
		end
	end

	def favourites_link_or_icon(favourites_style,favourite_id,artist)
		return favourite_icon(favourite_id) if favourites_style == :as_glypicon
		return add_or_remove(favourite_id,artist) if favourites_style == :as_link
		return "Invalid Favourites Style[#{favourites_style}]"
	end
	
	def favourite_icon(favourite_id)
		return '<span class="glyphicon glyphicon-music"></span>'.html_safe unless favourite_id.nil?
		return ""
	end
	
	def link_to_favourites_or_artists(page_style,letterstart)
		return artistsbypage_path(letterstart) if page_style == :page_artists
		return favadd_path(letterstart) if page_style == :page_favourites
		return "Unknown style"
	end
end
