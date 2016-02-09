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

RSpec.describe UsersController, :type => :controller do
  describe 'GET signup' do
 		it "assigns a new user to @user" do
 			get :new
 			expect(assigns(:user)).to be_a_new(User)
 		end

 		it "renders the :new template" do
 			get :new
 			expect(response).to render_template :new
 		end
 	end


 	describe "POST #create" do
 		context "with valid attributes" do
 			it "saves the new user in the database" do
 				expect{
 					post :create, user: attributes_for(:user)
 						}.to change(User, :count).by(1)
 			end
 			it "redirects to user#show" do
 				post :create, user: attributes_for(:user)
 				expect(response).to redirect_to user_path(assigns[:user])
 			end
 		end

 		context "with invalid attributes" do
 			it "does not save the new user in the database" do
 				expect{
 					post :create, user: attributes_for(:user, name: nil )
				}.not_to change(User, :count)
			end
 			it "re-renders the :new template" do
 				post :create,
 					user: attributes_for(:user, name: nil)
 				expect(response).to render_template :new
 			end
 		end
 end

 describe "Show user" do
		fixtures :users

  	context "unsuccessful when not logged in" do
  		it "redirects to login" do
  			user = users(:roy)
  			get :show, id: user
  			expect(response).to redirect_to(login_url)
  		end
  	end

  	context "successfull when logged in as current user" do
  		it "renders user page" do
				user = users(:roy)
				session[:user_id] = user.id
				get :show, id: user
				expect(response).to render_template :show
  		end
  	end

  	context "unsuccessful when logged in as different user" do
  		it "redirects to root" do
				user = users(:roy)
				session[:user_id] = user.id
				other_user = users(:archer)
				get :show, id: other_user
				expect(response).to redirect_to(root_url)
  		end
  	end
	end

	describe "Index of users" do
		fixtures :users

  	context "unsuccessful when not logged in" do
  		it "redirects to login" do
  			get :index
  			expect(response).to redirect_to(login_url)
  		end
  	end
  	context "successful when logged in" do
  		it "shows index list" do
  			user = users(:roy)
				session[:user_id] = user.id
  			get :index
  			expect(response).to render_template :index
  		end
  	end
  end

end
