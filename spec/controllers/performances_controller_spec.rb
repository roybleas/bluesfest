# == Schema Information
#
# Table name: performances
#
#  id              :integer          not null, primary key
#  daynumber       :integer
#  duration        :string
#  starttime       :time
#  title           :string
#  scheduleversion :string
#  festival_id     :integer
#  artist_id       :integer
#  stage_id        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe PerformancesController, :type => :controller do

  describe "GET showbyday" do
    it "returns http success" do
      get :showbyday, dayindex: 1
      expect(response).to have_http_status(:success)
    end
    it "returns empty array when no performances" do
      get :showbyday, dayindex: 1
      expect(assigns(:performances)).to be_empty
    end
  end
  context "Returns perfomance data" do
    before(:each) do
      performance = create(:performance_with_festival)
      @performances = [performance]
      get :showbyday, dayindex: 3
    end
    it "renders the showbyday template" do
        expect(response).to render_template :showbyday
    end
    it "assigns requested day performances" do
      expect(assigns(:performances)).to match_array(@performances)
    end
  end
  context "select by day" do
    it " returns a zero dayindex when no valid festival" do
      get :showbyday, dayindex: 2
      expect(assigns(:dayindex)).to eq 0
    end
    context "valid day index" do
      before(:each) do
        performance = create(:performance_with_just_festival)
        @performances = [performance]
      end       

      it "returns parameter dayindex" do
        get :showbyday, dayindex: 2
        expect(assigns(:dayindex)).to eq 2
      end
    end 
  end
  context 'number of festival days' do
    it "assigns 0 to days when no festival records" do
      get :showbyday, dayindex: 2
      expect(assigns(:festivaldays)).to eq 0
    end
    it "assigns 0 to days when no current festival" do
      festival = create(:festival_inactive)
      get :showbyday, dayindex: 2
      expect(assigns(:festivaldays)).to eq 0
    end
    it "assigns festival.days to days for current festival" do
      festival = create(:festival)
      get :showbyday, dayindex: 3
      expect(assigns(:festivaldays)).to eq festival.days
    end
  end
  context "select by day number" do
    before (:each) do
      @p = create(:performance_with_festival)
      @performances = [@p]
    end     
    it "returns empty when no performances match day number" do
      get :showbyday, dayindex: 2
      expect(assigns(:performances)).to be_empty
    end
    it "assigns matching day performance" do
      get :showbyday, dayindex: 3
      expect(assigns(:performances)).to match_array(@performances)
    end
    it "does not select other day performances" do
      performance = create(:performance, daynumber: 2, stage_id: @p.stage_id, festival_id: @p.festival_id)
      get :showbyday, dayindex: 2
      expect(assigns(:performances)).to match_array(performance)
    end
  end
  context "sort order" do
    it "assigns by startime ascending" do 
      performance2 = create(:performance_with_festival)
      performance1 = create(:performance, starttime: "9:16", stage_id: performance2.stage_id, festival_id: performance2.festival_id)
      performance3 = create(:performance, starttime: "20:00", stage_id: performance2.stage_id, festival_id: performance2.festival_id)
      performances = [performance1,performance2,performance3]
      get :showbyday, dayindex: 3
      expect(assigns(:performances)).to eq performances
    end
  end
  context "artist" do
    it "has an artist for each peformance" do
      f = create(:festival_with_stages_and_performances, stage_count: 1 )
      p = Performance.first
      artist = p.artist
      get :showbyday, dayindex: 1
      expect(assigns(:performances)[0].artist).to eq artist
    end
  end
  context "stage" do
    it "has a stage for each peformance" do
      f = create(:festival_with_stages_and_performances, stage_count: 1 )
      p = Performance.first
      stage = p.stage
      get :showbyday, dayindex: 1
      expect(assigns(:performances)[0].stage).to eq stage
    end
  end

  context "stages" do
    it "has empty stages when no current festival" do
      get :showbyday, dayindex: 1
      expect(assigns(:stages) ).to be_empty 
    end
    it "assigns stages" do
      festival = create(:festival_with_stages)
      stages = Stage.all
      get :showbyday, dayindex: 1
      expect(assigns(:stages) ).to match_array stages
    end     
    it "assigns stages in sequence" do
      festival = create(:festival_with_stages_random_order)
      get :showbyday, dayindex: 1
      (0..4).each do |index|
        expect(assigns(:stages)[index].seq).to eq index + 1
      end
    end
  end
  context "header" do
    it "assigns a peformance date" do
      festival = create(:festival, startdate: '2016-3-25')
      get :showbyday, dayindex: 2
      expect(assigns(:performancedate)).to eq "( Sat 26 March 2016 )"
    end
  end
  
  describe "index" do
    context "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:redirect)
      end
    end
    context "unsuccessful when not logged in" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(login_url)
      end
    end
    context "unsuccessful when not logged in as admin user" do
      it "redirects to login" do
        user = create(:user)
        session[:user_id] = user.id
        get :index
        expect(response).to redirect_to(root_url)
      end
    end
    context "successful when logged in" do
      it "shows index list" do  
        user = create(:admin_user)
        session[:user_id] = user.id
        get :index
        expect(response).to render_template :index
      end
    end
    context "when logged in as admin" do
      before(:example) do
        @logged_in_user =  create(:admin_user)
        session[:user_id] = @logged_in_user.id
      end
      it "returns empty array when no performances" do
        get :index
        expect(assigns(:performances)).to be_empty
      end
      it "assigns a performance to array" do
        performance = create(:performance_with_festival)
        performances = [performance]
        get :index
        expect(assigns(:performances)).to match_array(performances)
      end
      context "sort order" do
        it "assigns by startime ascending" do 
          performance2 = create(:performance_with_festival)
          performance1 = create(:performance, starttime: "9:16", stage_id: performance2.stage_id, festival_id: performance2.festival_id)
          performance3 = create(:performance, starttime: "20:00", stage_id: performance2.stage_id, festival_id: performance2.festival_id)
          performances = [performance1,performance2,performance3]
          get :index
          expect(assigns(:performances)).to eq performances
        end
        it "assigns by daynumber ascending" do  
          performance = create(:performance_with_festival)
          performance3 = performance
          performance2 = create(:performance, starttime: "9:16", stage_id: performance.stage_id, festival_id: performance.festival_id, daynumber: 2)
          performance1 = create(:performance, starttime: "20:00", stage_id: performance.stage_id, festival_id: performance.festival_id, daynumber: 1)
          performances = [performance1,performance2,performance3]
          get :index
          expect(assigns(:performances)).to eq performances
        end
        it "assigns by stage ascending" do
          performance = create(:performance_with_festival)
          stage3 = create(:stage, title: "Delta", code: "de", seq: 3, festival_id: performance.festival_id)
          stage2 = create(:stage, title: "Crossroads",  code: "cr", seq: 2, festival_id: performance.festival_id)
          performance2 = performance
          performance3 = create(:performance, stage_id: stage2.id, festival_id: performance.festival_id,daynumber: 3)
          performance1 = create(:performance, starttime: "11:00", stage_id: performance.stage_id, festival_id: performance.festival_id, daynumber: 3 )
          performance4 = create(:performance, starttime: "9:16", stage_id: stage3.id, festival_id: performance.festival_id, daynumber: 3)
          performances = [performance1,performance2,performance3,performance4]

          get :index
          expect(assigns(:performances)).to eq performances
        end 
        it "assigns by starttime within stage within daynumber" do
          performance = create(:performance_with_festival, starttime: "18:00")
          stage2 = create(:stage, title: "Crossroads",  code: "cr", seq: 2, festival_id: performance.festival_id)
          performance4 = performance
          performance5 = create(:performance, starttime: "16:00", stage_id: stage2.id, festival_id: performance.festival_id, daynumber: 3)
          performance2 = create(:performance, starttime: "10:00", stage_id: stage2.id, festival_id: performance.festival_id, daynumber: 1)
          performance1 = create(:performance, starttime: "15:00", stage_id: performance.stage_id, festival_id: performance.festival_id, daynumber: 1, )
          performance3 = create(:performance, starttime: "18:00", stage_id: stage2.id, festival_id: performance.festival_id, daynumber: 1)
          performances = [performance1,performance2,performance3,performance4,performance5]

          get :index
          expect(assigns(:performances)).to eq performances
        end 
      end
    end
  end
  describe "edit" do
    context "Non admin user" do
      before(:example) do 
        user = create(:user_in_sequence)
        session[:user_id] = user.id
        @performance = create(:performance)
      end
      context "GET edit" do
        it "returns http success" do
          get :edit, id: @performance.id
          expect(response).to have_http_status(:redirect)
        end
      end
      context "unsuccessful when not logged in" do
        it "redirects to login" do
          session[:user_id] = ""
          get :edit, id: @performance.id
          expect(response).to redirect_to(login_url)
        end
      end
      context "unsuccessful when not logged in as admin user" do
        it "redirects to login" do
          user = create(:user)
          session[:user_id] = user.id
          get :edit, id: @performance.id
          expect(response).to redirect_to(root_url)
        end
      end
    end
    context "Admin user" do
      before(:example) do 
        user = create(:user_in_sequence)
        user.update(admin: true)
        session[:user_id] = user.id
        @performance = create(:performance_with_just_festival)
      end
      context "GET edit" do
        it "returns http success" do
          get :edit, id: @performance.id
          expect(response).to have_http_status(:success)
        end
      end
      context "Patch" do
        context "valid attributes" do
          it "locates the requested @performance" do
            patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id)
            expect(assigns(:performance)).to eq(@performance)
          end
          it "changes @contact's attributes" do
          patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id,
              duration: '20 mins',
              daynumber: 2)
            @performance.reload
            expect(@performance.duration).to eq('20 mins')
            expect(@performance.daynumber).to eq(2)
          end
          it "accepts a daynumer of -1" do
            patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id,
              daynumber: -1)
            @performance.reload
            expect(@performance.daynumber).to eq(-1)
          end
          it "accepts a daynumer of 1" do
            patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id,
              daynumber: 1)
            @performance.reload
            expect(@performance.daynumber).to eq(1)
          end
          it "accepts a daynumer eq to max festival days" do
            max_days =  Festival.find(@performance.festival_id)[:days]
            patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id,
              daynumber: max_days)
            @performance.reload
            expect(@performance.daynumber).to eq(max_days)
          end
    
          it "redirects to the performance list" do
            patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id)
            expect(response).to redirect_to performances_url
          end
        end
        context "invalid attributes for day number" do
          # assumed administrator will only edit occasional late fixes and will enter correct data. 
          # just validate day number against festival and numeric
          it "rejects daynumber outside festival range" do
            patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id,
              daynumber: 6)
            @performance.reload
            expect(@performance.daynumber).to_not eq(6)
            expect(flash[:error]).to match(/Invalid daynumber = 6 with festival days set to 5/)
          end
          it "rejects daynumber of zero" do
            patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id,
              daynumber: 0)
            @performance.reload
            expect(@performance.daynumber).to_not eq(0)
            expect(flash[:error]).to match(/Invalid daynumber = 0 with festival days set to 5/)
          end
          it "rejects daynumber less than -1" do
            patch :update, id: @performance, performance: attributes_for(:performance, festival_id: @performance.festival_id,
              daynumber: -2)
            @performance.reload
            expect(@performance.daynumber).to_not eq(0)
            expect(flash[:error]).to match(/Invalid daynumber = -2 with festival days set to 5/)
          end
        end
      end
    end
  end
end
