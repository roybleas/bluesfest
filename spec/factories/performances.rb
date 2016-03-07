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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	
  factory :performance do
    daynumber 3
    duration "60 mins"
    starttime "19:15"
    scheduleversion "20160216B"
    title "performance caption"
    festival nil
    artist nil
    stage nil
    factory :performance_with_festival, class: Performance do
  		festival
  		artist
  		stage
		end
		factory :performance_with_just_festival, class: Performance do
			festival
		end
		factory :performance_with_artist, class: Performance do
			artist
		end
		factory :performance_with_artist_and_stage, class: Performance do
			artist
			stage
		end
		factory :peformance_first_schedulefile, class: Performance do
			starttime '22:45'
			daynumber 1
			scheduleversion 'testdata'
			duration '10 min'
			festival
			stage
			association :artist, factory: :artist, name: "KENDRICK Lamar", code: "kendricklamar"
   		
		end
  end
  
end
