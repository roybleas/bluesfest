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

require 'rails_helper'

RSpec.describe StagesController, :type => :controller do
	context "index" do
	  describe "GET index" do
	    it "returns http success" do
	      get :index
	      expect(response).to have_http_status(:success)
	    end
	  end
	end
	context "show" do
	  describe "GET show route" do
	    it "returns http success" do
	      get :show, id: 1, dayindex: 2
	      expect(response).to have_http_status(:success)
	    end
	  end
	  describe 'GET #show' do
			it "assigns the requested stage " do
				stage = create(:stage_with_festival)
				get :show, id: stage, dayindex: 1
				expect(assigns(:stage)).to eq stage
				expect(assigns(:dayindex)).to eq 1
			end
			it "renders the :show template" do
				stage = create(:stage)
				get :show, id: stage, dayindex: 1
				expect(response).to render_template :show
			end
		end
		describe 'day_index parameter' do
			before(:each) do
				festival = create(:festival,days: 3)
				@stage = create(:stage, festival_id: festival.id)
			end				
			it 'has the first valid day index ' do
				get :show, id: @stage, dayindex: 1
				expect(assigns(:dayindex)).to eq 1
			end
			it 'has the last valid day index ' do
				get :show, id: @stage, dayindex: 3
				expect(assigns(:dayindex)).to eq 3
			end
			it 'resets index to first if less than minimum' do
				get :show, id: @stage, dayindex: 0
				expect(assigns(:dayindex)).to eq 1
			end

		end
	end
end
