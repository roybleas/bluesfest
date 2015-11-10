require 'rails_helper'

RSpec.describe "static_pages/home.html.erb", :type => :view do
  it "displays the home page" do
  	render
  	expect(rendered).to match /Home Page/
  end
end
