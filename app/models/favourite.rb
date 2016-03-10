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

class Favourite < ActiveRecord::Base
  belongs_to :artist
  belongs_to :user
  
  def self.for_user(user)
  	where(user_id: user)
  end
end
