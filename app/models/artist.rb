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

class Artist < ActiveRecord::Base
  belongs_to :festival
  has_many :performances
  has_many :favourites
  
  validates :name, presence: true
  
  def self.current_active
		where('artists.active = true').order(name: :desc)
	end
	def self.current_active_festival
		joins(:festival).where('artists.active = true and festivals.active = true')
	end
	def self.by_festival(festival)
		where('festival_id = ?', festival.id)
	end
  def self.by_letter_range(letterstart, letterend)
  	where('name >= ? and name < ? and artists.active = true', letterstart, letterend)
  end
  def self.starting_with_letter(letterstart)
  	where('name >= ? and artists.active = true', letterstart)
  end
	
	def self.by_code_and_festival_id(artist_code,festival_id)
		where("artists.code = ? and artists.festival_id = ?",artist_code,festival_id)
	end
	
	def self.artists_by_range(page_range)
		if page_range[:letterend].nil?
			return self.starting_with_letter(page_range[:letterstart]) 
		else
			return self.by_letter_range(page_range[:letterstart], page_range[:letterend])
		end
	end	
	def self.select_with_fav_user_id
		select('artists.*, fav.user_id as fav_user_id')
	end
	def self.joins_favourites
		joins(" right join artists on fav.artist_id = artists.id ")
	end
	def self.with_user_favourites(user_id)
		joins('full join favourites on artists.id = favourites.artist_id').where('favourites.user_id = ? or favourites.user_id is null',user_id)	
	end
	def self.active_artist
	 where 'artists.active = true'
	end
end