require 'rails_helper'

RSpec.describe "stages/show.html.erb", :type => :view do
  it "shows missing artist" do
    render
    expect(rendered).to match /Unknown Stage/
  end
  context "stage selection table" do
    before(:each) do
      assign(:days, 5)
    end 
     it "shows stage title" do
      stage = create(:stage)
      assign(:stage, stage)
      assign(:dayindex, 1)
      assign(:previousdayindex,1)
      assign(:nextdayindex,3)
      assign(:previousstage,stage)
      assign(:nextstage,stage)
      assign(:stages, [stage])
      assign(:performances,[])
      render
      expect(rendered).to match /#{stage.title}/
    end
  end
  context "show day and date information" do
    before(:each) do
      stage = create(:stage)
      assign(:stage, stage)
      assign(:stages, [stage])
      assign(:performances,[])
      assign(:days, 5)
      assign(:previousdayindex,5)
      assign(:nextdayindex,2)
      assign(:previousstage,stage)
      assign(:nextstage,stage)

    end
    it "shows the day number" do
      assign(:dayindex, 1)
      render
      expect(rendered).to match /Day: 1/
    end
    it "shows the day of week" do
      assign(:dayofweek, "Fri")
      assign(:dayindex, 1)      
      render
      expect(rendered).to match /\( Fri \)/
    end
  end 
  context "navigate to previous/next day of week" do
    before(:each) do
      @stage = create(:stage)
      assign(:stage, @stage)
      assign(:stages, [@stage])
      assign(:performances,[])
      assign(:days, 5)
      assign(:previousdayindex,1)
      assign(:nextdayindex,3)
      assign(:previousstage,@stage)
      assign(:nextstage,@stage)
      assign(:dayindex,2)
    end

    it " shows arrows " do
      render
      assert_select "a span.glyphicon-circle-arrow-left", 2
      assert_select "a span.glyphicon-circle-arrow-right", 2
    end
    it "has previous day link" do
      render
      assert_select "a[href=?]",  "/stages/#{@stage.id}/1"
    end
    it "has next day link" do
      render
      assert_select "a[href=?]",  "/stages/#{@stage.id}/3"
    end

  end
  context "navigate to previous/next stage" do
    before(:each) do
      
      @stage0 = create(:stage)
      @stage1 = create(:stage, title: 'stage 2', seq: 2)
      @stage2 = create(:stage, title: 'stage 3', seq: 3)
      assign(:stage, @stage1)
      assign(:stages, [@stage0,@stage1,@stage2])
      assign(:performances,[])
      assign(:days, 5)
      assign(:previousdayindex,1)
      assign(:nextdayindex,3)
      assign(:previousstage,@stage0)
      assign(:nextstage,@stage2)
      assign(:dayindex,2)
    end

    it "has previous stage link" do
      render
      assert_select "a[href=?]",  "/stages/#{@stage0.id}/2" , {count: 2}
    end
    it "has next day link" do
      render
      assert_select "a[href=?]",  "/stages/#{@stage2.id}/2", {count: 2}
    end

  end
  
  context "performance" do
    before(:each) do
      @performance = create(:performance_with_festival)
      performances = Performance.all
      stage = Stage.first
      @artist = Artist.first
      assign(:stage, stage)
      assign(:stages,Stage.all)
      assign(:days,5)
      assign(:dayindex,1)
      assign(:previousdayindex,5)
      assign(:nextdayindex,2)
      assign(:previousstage,stage)
      assign(:nextstage,stage)
      assign(:performances, performances) 
    end
    it "shows start time" do
      render
      expect(rendered).to match /19:15/ 
    end
    it "shows artist" do
      render
      performance_title = @performance.title
      artist_id = @performance.artist_id
      expect(rendered).to match /<a href="\/artists\/#{artist_id}">#{performance_title}<\/a>/
    end
    it "shows link to external website" do
      link_id = @artist.linkid
      render
      expect(rendered).to match /http:\/\/www.bluesfest.com.au\/schedule\/detail.aspx\?ArtistID=#{link_id}/
    end
    it "shows duration" do
      render
      expect(rendered).to include('(60 mins)')
    end
    it "hides brackets when blank duration" do
      @performance.duration = ""
      @performance.save
      performances = Performance.all
      assign(:performances, performances)
      render
      expect(rendered).to_not include('()')
    end
    
  end
end
