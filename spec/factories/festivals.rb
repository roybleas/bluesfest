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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :festival do
  	startdate "2016-03-24"
    days 5
    scheduledate "2016-01-28"
    year "2016"
    title "Bluesfest"
    major 1
    minor 2
    active true
    
  	factory :festival_inactive, class: Festival do
  		active false
  	end
  	
  end
  
end
