# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  screen_name     :string
#  password_digest :string
#  remember_digest :string
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "Mr Flinstone"
    screen_name "Fred"
    password "foobar"
    password_confirmation "foobar"
    admin false
  end
  factory :admin_user, class: User do
    name "Mr Rubble"
    screen_name "Barney"
    password "password"
    password_confirmation "password"
    admin true
  end
  
  factory :test_user, class: User do
    name "Mrs Flintstone"
    screen_name "Wilma"
    password "password"
    password_confirmation "password"
    admin true
  end
  
end
