# == Schema Information
#
# Table name: festivals
#
#  id           :integer          not null, primary key
#  startdate    :date
#  days         :integer
#  scheduledate :date
#  year         :string
#  title        :string
#  major        :integer
#  minor        :integer
#  active       :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Festival < ActiveRecord::Base
	has_many :artists
	
	def self.current_active
		where('festivals.active = true').order(startdate: :desc)
	end

end
