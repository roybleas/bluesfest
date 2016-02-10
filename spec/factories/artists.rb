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
    code "123"
    active false
    extractdate "2016-02-08"
    festival nil
    
    factory :artist_with_festival, class: Artist do
    	active true
  		festival
  	end
  end
end