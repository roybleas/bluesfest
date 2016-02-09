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
#  tester          :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

module UsersHelper
end
