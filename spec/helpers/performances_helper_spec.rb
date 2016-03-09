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
  describe "find_matching_stage_index" do
  	before(:example) do
  		#stage_index,stage_count,performance,stages
  		festival = create(:festival_with_stages)
  		@stages = Stage.all
  		@performance = create(:performance,stage_id: @stages[1].id)
  		@stage_count = @stages.count
  	end
  	it "returns nil if end of stage list" do
  		stage_index = 5
  		expect(helper.find_matching_stage_index(stage_index,@stage_count,@performance,@stages)).to be_nil
  	end
  	it "returns index before" do
  		stage_index = 1
  		expect(helper.find_matching_stage_index(stage_index,@stage_count,@performance,@stages)).to eq 1
  	end
  	
  end

end
