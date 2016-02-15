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
	    it "assigns empty stages array when no stage records exist" do
	    	get :index
	    	expect(assigns(:stages)).to be_empty
	    end
	    it "assigns empty stage array when no festival record" do
	    	get :index
	    	expect(assigns(:stages)).to be_empty
			end		
	    it "assigns empty stage array when no records linked to festival record" do
	    	get :index
	    	expect(assigns(:stages)).to be_empty
			end
	    it "assigns a stage record linked to current festival to stage array" do
	    	s = create(:stage_with_festival)
	    	get :index
	    	expect(assigns(:stages)).to match_array(s)
			end
			it "assigns multiple stage records to stage array" do
				s = create(:stage_with_festival)
				s1 = create(:stage, festival_id: s.festival_id, seq: 2)
				get :index
				expect(assigns(:stages)).to match_array([s,s1])
			end
			it "assigns multiple soreted stage records to stage array" do
				s = create(:stage_with_festival, seq: 3)
				s1 = create(:stage, festival_id: s.festival_id, seq: 1)
				s2 = create(:stage, festival_id: s.festival_id, seq: 2)
				get :index
				expect(assigns(:stages)).to eq([s1,s2,s])
			end
			it "assigns 0 to days when no festival records" do
				get :index
				expect(assigns(:days)).to eq 0
			end
			it "assigns 0 to days when no current festival" do
				festival = create(:festival_inactive)
				get :index
				expect(assigns(:days)).to eq 0
			end
			it "assigns festival.days to days for current festival" do
				festival = create(:festival)
				get :index
				expect(assigns(:days)).to eq festival.days
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
		describe 'day of the week without festival record' do
			it "retuns nil day of the week" do
				get :show, id: 1, dayindex: 1
				expect(assigns(:dayofweek)).to be_nil
			end
		end
		describe 'actual date of day index' do			
			before(:each) do
				@festival = create(:festival,days: 3, startdate: '2016-03-1')
				@stage = create(:stage, festival_id: @festival.id)
			end				
			it 'returns date of first day of festival' do
				get :show, id: @stage, dayindex: 1
				expect(assigns(:dayofweek)).to eq Date.parse('2016-03-01').strftime("%a %d %b")
			end
			it 'returns date of third day of festival' do
				get :show, id: @stage, dayindex: 3
				expect(assigns(:dayofweek)).to eq Date.parse('2016-03-03').strftime("%a %d %b")
			end
			it 'returns date of last day of festival when invalid day index' do
				get :show, id: @stage, dayindex: 31
				expect(assigns(:dayofweek)).to eq Date.parse('2016-03-03').strftime("%a %d %b")
			end
			it 'returns date of festival in following month with invalid day index' do
				@festival.update(days: 40)
				get :show, id: @stage, dayindex: 32
				expect(assigns(:dayofweek)).to eq Date.parse('2016-04-01').strftime("%a %d %b")
			end
		end
		describe 'number of festival days' do
			it "assigns 0 to days when no festival records" do
				get :show, id: 1, dayindex: 3
				expect(assigns(:days)).to eq 0
			end
			it "assigns 0 to days when no current festival" do
				festival = create(:festival_inactive)
				get :show, id: 1, dayindex: 3
				expect(assigns(:days)).to eq 0
			end
			it "assigns festival.days to days for current festival" do
				festival = create(:festival)
				get :show, id: 1, dayindex: 3
				expect(assigns(:days)).to eq festival.days
			end
		end
	end
end
