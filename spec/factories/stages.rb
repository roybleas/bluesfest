# == Schema Information
#
# Table name: stages
#
#  id          :integer          not null, primary key
#  title       :string
#  code        :string(2)
#  seq         :integer
#  festival_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stage do
    title "Mojo"
    code 'mo'
    seq 1
    festival nil
   	
   	factory :stage_with_festival, class: Stage do
  		festival
  	end

  end
end
