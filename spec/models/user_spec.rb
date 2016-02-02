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

require 'rails_helper'

RSpec.describe User, :type => :model do
  
  it "is valid with a name and screen name" do
  	user = User.new(
  		name: 'Test User',
  		screen_name: 'Testme',
  		password: "foobar", password_confirmation: "foobar"
  		)
  		expect(user).to be_valid
  end
	
	it "is invalid without a name" do
		user = User.new(name: nil)
		user.valid?
		expect(user.errors[:name]).to include("can't be blank")
	end
	
	it "is invalid without a screen name" do
		user = User.new(screen_name: nil)
		user.valid?
		expect(user.errors[:screen_name]).to include("can't be blank")
	end
	
	it "is valid with a different name but duplicate screen name" do
		User.create(
  		name: 'Test User',
  		screen_name: 'Testme',
  		password: "foobar", password_confirmation: "foobar"
  		)
  	user = User.new(
  		name: 'Test User 2',
  		screen_name: 'Testme',
  		password: "foobar", password_confirmation: "foobar"
  		)
  	user.valid?
  	expect(user).to be_valid
  end	
  
	it "is invalid with a duplicate name" do
		User.create(
  		name: 'Test User',
  		screen_name: 'Testme',
  		password: "foobar", password_confirmation: "foobar"
  		)
  	user = User.new(
  		name: 'Test User',
  		screen_name: 'Testme',
  		password: "foobar", password_confirmation: "foobar"
  		)
  	user.valid?
  	expect(user.errors[:name]).to include("has already been taken")
  end
  
  it "is invalid with a password lenght less than 6 characters" do
  	user = User.new(
  		name: 'Test User',
  		screen_name: 'Testme',
  		password: "a" * 5, password_confirmation: "a" * 5
  		)
  	user.valid?
  	expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end
  
  it "is invalid to have a user name > 50 characters" do
  	user = User.new(
  		name: "a" * 51,
  		screen_name: "test screen name",
  		password: "foobar", password_confirmation: "foobar"
  		)
  	user.valid?
  	expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
  end
  	
  it "is invalid to have a screen name > 20 characters" do
  	user = User.new(
  		name: 'Test User',
  		screen_name: "a" * 21,
  		password: "foobar", password_confirmation: "foobar"
  		)
  	user.valid?
  	expect(user.errors[:screen_name]).to include("is too long (maximum is 20 characters)")
  end
  
  it "can be created with Factory Girl" do
  	user = FactoryGirl.build(:user)
  	expect(user).to be_valid
  end
  
  it "is valid for user with nil digest to return a false authentication test" do
  	user = User.new(
  		name: 'A Test User',
  		screen_name: 'Testme',
  		password: "foobar", password_confirmation: "foobar"
  		)

    expect(user.authenticated?(''))
  end
end
