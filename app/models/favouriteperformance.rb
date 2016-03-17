# == Schema Information
#
# Table name: favouriteperformances
#
#  id             :integer          not null, primary key
#  performance_id :integer
#  active         :boolean          default(TRUE)
#  favourite_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Favouriteperformance < ActiveRecord::Base
  belongs_to :favourite
  belongs_to :performance
end
