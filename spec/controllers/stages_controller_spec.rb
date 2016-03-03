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
			it 'has the first valid day index ' do
				stage = create(:stage_with_festival)
				get :show, id: stage, dayindex: 1
				expect(assigns(:dayindex)).to eq 1
			end
		end
		describe 'day of the week ' do
			it "retuns first day of festival as formated date" do
				stage = create(:stage_with_festival)
				get :show, id: stage, dayindex: 1
				expect(assigns(:dayofweek)).to eq Date.parse('2016-03-24').strftime("%a")
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
	context "navigate to other days" do
		it "has previous day index as 1 less than current day index" do
			festival = create(:festival)
			get :show, id: 1, dayindex: 3
			expect(assigns(:previousdayindex)).to eq 2
		end
		it "has next day index as 1 greater than current day index" do
			festival = create(:festival)
			get :show, id: 1, dayindex: 1
			expect(assigns(:nextdayindex)).to eq 2
		end
	end
	context "navigate to other months" do
		before(:each) do
			festival = create(:festival_with_stages)
			@stages = Stage.order(seq: :asc).all
			@stage = @stages[1]
		end		
		it "has previous stage in sequence to current stage" do
			get :show, id: @stage, dayindex: 3
			expect(assigns(:previousstage)).to eq @stages[0]
		end
		it "has next stage in sequence to current stage" do
			get :show, id: @stage, dayindex: 3
			expect(assigns(:nextstage)).to eq @stages[2]
		end

	end
	context "performances" do
		it "returns performances" do
			f = create(:festival_with_stages_and_performances, stage_count: 1, performance_count: 1)
			performances = Performance.all
			s = Stage.first
			get :show, id: s.id, dayindex: 1
			expect(assigns(:performances)).to match_array(performances)
		end
		it "returns performances by stage" do
			f = create(:festival_with_stages_and_performances, stage_count: 2, performance_count: 1)
			s = Stage.last
			performances = Performance.where("stage_id = ",s.id).all
			get :show, id: s.id, dayindex: 1
			expect(assigns(:performances).count).to eq 1
		end
		it "returns performances by stage and day number" do
			f = create(:festival_with_stages_and_performances, stage_count: 2, performance_count: 1, day_count: 2)
			s = Stage.last
			performances = Performance.where("stage_id = ",s.id).all
			get :show, id: s.id, dayindex: 2
			expect(assigns(:performances).count).to eq 1
		end
		it "returns performances in descending starttime" do
			f = create(:festival_with_stages_and_performances, stage_count: 1, performance_count: 4)
			p = Performance.first(4)
			p[0].update(starttime: '10:00')
			p[1].update(starttime: '19:16')
			p[2].update(starttime: '18:15')
			p[3].update(starttime: '19:00')
			performances_desc = [p[1],p[3],p[2],p[0]]
			s = Stage.first
			get :show, id: s.id, dayindex: 1
			expect(assigns(:performances)).to eq(performances_desc)
		end
	end
end
