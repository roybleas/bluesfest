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
end
