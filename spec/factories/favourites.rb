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
  factory :favourite_with_artist_and_user, class: Favourite do
  	artist
  	user
  end
end
