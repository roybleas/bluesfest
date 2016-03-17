# == Schema Information
#
# Table name: favouriteperformances
#
#  id             :integer          not null, primary key
#  performance_id :integer
#  active         :boolean
#  favourite_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :favouriteperformance do
    performance_id 1
    active true
    favourite nil
  end
  factory :favourite_for_favouriteperformance, class: Favouriteperformance do
		performance_id 1
    active true
    favourite
  end
  factory :user_for_favourites_with_performances, class: User do
  	sequence(:name) { |n| "person#{n}" }
    screen_name "some name"
    password "foobar"
    password_confirmation "foobar"
    admin false
    tester false

    ignore do
    	performance_count  3
    end
    
    after(:create) do |user, evaluator|	
    	artist = create(:artist)
    	favourite = create(:favourite, artist_id: artist.id, user_id: user.id)
    	1.upto(evaluator.performance_count.to_i).each do |index|
    		performance = create(:performance, artist_id: artist.id, daynumber: index)
    		favouriteperformance = create(:favouriteperformance,favourite_id: favourite.id, performance_id: performance.id)
			end
		end
	end
	factory :user_for_favourites_with_performances_and_stage, class: User do
  	sequence(:name) { |n| "person_#{n}" }
    screen_name "some name"
    password "foobar"
    password_confirmation "foobar"
    admin false
    tester false

    ignore do
    	performance_count  3
    end
    
    after(:create) do |user, evaluator|	
    	artist = create(:artist)
    	favourite = create(:favourite, artist_id: artist.id, user_id: user.id)
    	stage = create(:stage)
    	1.upto(evaluator.performance_count.to_i).each do |index|
    		performance = create(:performance, artist_id: artist.id, daynumber: index, stage_id: stage.id)
    		favouriteperformance = create(:favouriteperformance,favourite_id: favourite.id, performance_id: performance.id)
			end
		end
	end
end
