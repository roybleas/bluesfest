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

class User < ActiveRecord::Base
	attr_accessor :remember_token
	
	validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
	validates :screen_name, presence: true, length: { maximum: 20 }
		
	has_secure_password
	validates :password, length: { minimum: 6 }, allow_nil: true

	# Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_token
  	SecureRandom.urlsafe_base64
  end
  
  # Stores the remember token used to persit the session
  def remember
  	self.remember_token = User.new_token
  	update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
  	if remember_digest.nil?
  		false
  	else
    	BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
  end
  
  #forget the User
  def forget
  	update_attribute(:remember_digest, nil)
  end
  

end
