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
  
  validates :name, presence: true
  
  def self.current_active
		where('artists.active = true').order(name: :desc)
	end
	def self.current_active_festival
		joins(:festival).where('artists.active = true and festivals.active = true')
	end
	
	def self.by_code_and_festival_id(artist_code,festival_id)
		where("artists.code = ? and artists.festival_id = ?",artist_code,festival_id)
	end
	
end
