require 'rails_helper'

RSpec.describe "static_pages/about.html.erb", :type => :view do
  it "displays the about page" do
  	render
  	expect(rendered).to match /Version/
  end
end
