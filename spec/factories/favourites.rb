# == Schema Information
#
# Table name: favourites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  artist_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :favourite do
    user_id 1
    artist nil
  end
  factory :favouriteuser, class: User do
  	sequence(:name) { |n| "Mr Logged In #{n}" }
    screen_name "Justin"
    password "foobar"
    password_confirmation "foobar"
    admin false
    tester false
    
    factory :user_for_favourite, class: User do
	    ignore do
	    	artist_count  1
	    end
	    
	    after(:create) do |user, evaluator|	
	    	(1..evaluator.artist_count).each do |i|
	    		artist = create(:artist)
	    		favourite = create(:favourite,user_id: user.id, artist_id: artist.id)
				end
			end
		end		
		factory :user_for_favourites_with_desc_artist_list_name, class: User do
	    ignore do
	    	artist_count  3
	    end
	    
	    after(:create) do |user, evaluator|	
	    	evaluator.artist_count.downto(1).each do |index|
	    		artist = create(:artist, name: "#{index} - artist")
	    		favourite = create(:favourite,user_id: user.id, artist_id: artist.id)
				end
			end
		end
  end
  
end
