require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
		
	describe "POST create" do
		
		
		context "with valid log in" do
		
	    it "creates a session" do
	    	user = create(:user)
	    	post :create, session: {name: user.name, password: 'foobar' }
	     	expect(response).to redirect_to user
	    end
	  end
	  
	  context "with invalid log in" do
		
	    it "fails to creates a session" do
	    	user = create(:user)
	    	post :create, session: {name: user.name, password: 'wrongpassword' }
	     	expect(response).to render_template :new
	    end
	  end
	  
	  context "with valid log in and remember me not set" do
	    it "creates a session without cookie" do
	    	user = create(:user)
	    	post :create, session: {name: user.name, password: 'foobar', remember_me: '0' }
	     	expect(cookies['remember_token']).to be_nil
	    end
	  end
	  
	   context "with valid log in and remember me set" do
	    it "creates a session with cookie" do
	    	user = create(:user)
	    	post :create, session: {name: user.name, password: 'foobar', remember_me: '1' }
	     	expect(cookies['remember_token']).to_not be_nil
	    end
	  end  
  end
  
 	describe "DELETE destroy " do
 		
 		context "when not logged in" do
  		it "still redirects " do
  			delete :destroy
  			expect(response).to redirect_to root_url
  		end
  	end
  	
  	context "when logged in" do
  		it "deletes and redirects " do
  			user = create(:user)
	    	post :create, session: {name: user.name, password: 'foobar', remember_me: '0' }
  			delete :destroy
  			expect(response).to redirect_to root_url
  			
  		end
  		
  		it "deletes and clears remember token " do
  			user = create(:user)
	    	post :create, session: {name: user.name, password: 'foobar', remember_me: '1' }
  			delete :destroy
  			expect(cookies['remember_token']).to be_nil
  		end
  	end
  end
  		

end
