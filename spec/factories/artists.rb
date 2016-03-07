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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :artist do
    name "Tom Jones"
    code "tomjones"
    linkid "123"
    active false
    extractdate "2016-02-08"
    festival nil
    
    factory :artist_with_festival, class: Artist do
    	active true
  		festival
  	end
  	factory :artist_sequence, class: Artist do
  		sequence(:name) { |n| "artist_%02d" % n }
  		sequence(:linkid) { |n| "link id #{n}"}
  		active = true
  	end	
  	factory :artist_first_schedule, class: Artist do 
    	name "KENDRICK Lamar"
    	code "kendricklamar"
    	linkid "123"
    	active false
    	extractdate "2016-02-08"
  	end
  end
end
