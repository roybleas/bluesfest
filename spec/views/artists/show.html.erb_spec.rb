require 'rails_helper'
require 'date'

RSpec.describe "artists/show.html.erb", :type => :view do
  it "shows artist name" do
    artist = create(:artist)
    assign(:artist, artist)
    assign(:performances,[])
    render
    expect(rendered).to match /#{artist.name}/
  end
  it "shows missing artist" do
    render
    expect(rendered).to match /Unknown Artist/
  end
  it "shows link to default artists index ie by 'a'" do
    render
    assert_select "a[href=?]", "/artists/bypage/a"
    assert_select "a", "Artists"
  end
  it "shows link to artists page " do
    artist = create(:artist)
    assign(:artist, artist)
    assign(:performances,[])
    render
    assert_select "a[href=?]", "/artists/bypage/t"
    assert_select "a", "Artists"
  end

  context "performances" do
    before(:each) do
      performance = create(:performance_with_festival)
      @performances = [performance]
      @artist = Artist.first
    end
    it "shows stage name" do
      stage = Stage.first
      assign(:stage,stage)
      render
      expect(rendered).to match /#{stage.title}/
    end
    it "shows link to stage" do
      stage = Stage.first
      assign(:stage,stage)
      @performances[0].daynumber = 2
      render
      expect(rendered).to match /<a class="stagelink" href="\/stages\/#{stage.id}\/2">Mojo<\/a>/
    end
    it "shows stage class set to stage code" do
      stage = Stage.first
      assign(:stage,stage)
      render
      expect(rendered).to match /id="color-#{stage.code}"/
    end
    it "shows day number" do
      @performances[0].daynumber = 2
      render
      expect(rendered).to match /Day: 2/ 
    end
    it "shows day of week" do
      @performances[0].daynumber = 2
      assign(:startdate_minus_one, Date.new(2016,4,1))
      render
      expect(rendered).to match /Sun/
    end
    it "shows duration" do
      render
      expect(rendered).to include('(60 mins)')
    end
    it "hides brackets when blank duration" do
      @performances[0].duration = ""
      render
      expect(rendered).not_to include('()')
    end

  end
  context "link to favoutes" do
    
    context "when logged in"
    before(:example) do
      allow(view).to receive_messages(:logged_in? => true)
      performance = create(:performance_with_festival)
      @performances = [performance]
      @artist = create(:artist)     
    end
    
    it "shows post if not already a favourite" do
      render
      assert_select "a[href=?]", "/favourites?id=#{@artist.id}" 
      assert_select "a[data-method=?]", "post"
      expect(rendered).to match /#{@artist.name} to favourites/
    end     
    it "shows delete when a favourite" do
      user = create(:user)
      favourite = create(:favourite, artist_id: @artist.id, user_id: user.id)
      assign(:favourite_artist,favourite)
      render
      assert_select "a[href=?]", "/favourites/#{favourite.id}" 
      assert_select "a[data-method=?]", "delete"
      expect(rendered).to match /#{@artist.name} from favourites/
    end

  end
end

