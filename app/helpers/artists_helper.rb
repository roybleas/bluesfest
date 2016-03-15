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
	
	def add_or_remove(favourite,artist)
		if favourite.nil?
			return link_to "Add", favourites_path(:id => artist.id), :method => :post, class: "btn btn-info btn-sm", "role" => "button"
		else
			return link_to "Remove", favourite, method: :delete,  class: "btn btn-danger btn-sm", "role" => "button"
		end
	end
	
	def add_or_remove_caption(favourite, artist)
		if favourite.nil?
			return " #{artist.name} to favourites. ".html_safe
		else
			return " #{artist.name} from favourites. ".html_safe
		end
	end

end
