require 'rails_helper'

RSpec.describe "stages/index.html.erb", :type => :view do
  it "shows no stages message when empty list" do
  	assign(:stages,[])
  	render
  	expect(rendered).to match /No stages set/
  end
  
end
