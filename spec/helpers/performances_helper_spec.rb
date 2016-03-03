require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PerformancesHelper. For example:
#
# describe PerformancesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PerformancesHelper, :type => :helper do
  describe "outstanding_stage_cells" do
  	it "returns empty string when index passed last stage" do
  		expect(helper.outstanding_stage_cells(5,5)).to eq ""
  	end
  end
end
