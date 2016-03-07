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

class Performance < ActiveRecord::Base
  belongs_to :festival
  belongs_to :artist
  belongs_to :stage
  
  def self.for_day(daynumber)
  	where('performances.daynumber = ? ',daynumber)
  end
	def self.for_festival(festival)
		where('performances.festival_id = ? ',festival.id)
	end
	def self.for_stage(stage_id)
		where('stage_id = ?',stage_id)
	end
	def self.for_artist(artist_id)
		where('artist_id = ?',artist_id)
	end
	def self.by_artist_stage_day_starttime_and_festival(artist_id, stage_id, daynumber, starttime, festival_id)
		where('artist_id = ? and stage_id = ? and daynumber = ? and starttime = ? and festival_id = ?',artist_id, stage_id, daynumber, starttime, festival_id)
	end
end
