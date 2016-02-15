require 'rails_helper'

RSpec.describe "stages/_stageselect.html.erb", :type => :view do
	it "displays table heading" do
		stages = []
    render :partial => "stageselect.html.erb",  :locals => {:days => 5, :stages => stages}

    assert_select 'th', "Stage"
    assert_select 'th', "Days"
    expect(rendered).to match /colspan="5"/
  end
  it "displays a stage" do
  	stage1 = create(:stage_with_festival)
  	stages = [stage1]
  	color_id = "color-#{stage1.code}"
  	render :partial => "stageselect.html.erb", :locals => {:days => 5, :stages => stages}
  	assert_select 'td',{:id => color_id, :text=>"#{stage1.title}"}
  	assert_select 'td',{:class=>"select", :text=>"Day 1"}
  	assert_select 'td',{:class=>"select", :text=>"Day 5"}
  	assert_select "a[href=?]", "/stages/#{stage1.id}/1"
  	assert_select "a[href=?]", "/stages/#{stage1.id}/1"
  end

end