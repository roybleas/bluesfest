require 'rails_helper'
require './app/services/load_service.rb'
require 'date'        

RSpec.describe "load services" do
	context "Stages" do
		context "with festival data file" do
			before(:each) do
				filename = './spec/files/festival.yml'
				@currentFestival = CurrentFestival.new(filename)
				@currentFestival.load
				@csv_filename = './spec/files/stages.csv'
			end
			it "does not have a festival record " do
				cLoad = LoadStages.new('invalid',@currentFestival)
				expect{cLoad.load}.to raise_error(LoadStageError,/Festival database record not found/)
			end
			it "does not match the requested festival record " do
				festival = create(:festival, title: "alternative title", startdate: @currentFestival.startdate)
				cLoad = LoadStages.new(@csv_filename,@currentFestival)
				expect{cLoad.load}.to raise_error(LoadStageError,/Festival database record not found/)
			end
			context "with valid festival record" do
				before(:each) do
					festival = create(:festival, title: @currentFestival.title, startdate: @currentFestival.startdate)
					@festival_id = festival.id
					@cLoad = LoadStages.new(@csv_filename,@currentFestival)
				end
				it "raises error when stages file not found " do
					cLoad = LoadStages.new("invalid",@currentFestival) 
					expect{cLoad.load}.to raise_error(/No such file or directory/)
				end
				it "finds current festival record" do
					expect{@cLoad.load}.to_not raise_error
				end
				it "adds stages" do
					expect{@cLoad.load}.to change(Stage, :count).by(5)
				end
				it "puts out a summary message" do
					expect{@cLoad.load}.to output(/Added: 5 and updated: 0 Stages/).to_stdout
				end
				it "updates stages" do
					@cLoad.load
					expect{@cLoad.load}.to change(Stage, :count).by(0)
				end
				it "puts out a summary message" do
					@cLoad.load
					expect{@cLoad.load}.to output(/Added: 0 and updated: 5 Stages/).to_stdout
				end
				it "adds record correctly" do
					@cLoad.load 
					stage_code = 'ju' 
					stage_title = 'Juke Joint'
					stage_seq = 5
					stage = Stage.by_code_and_festival_id(stage_code,@festival_id).take
					expect(stage).to_not be_nil
					expect(stage.title).to eq stage_title
					expect(stage.code).to eq stage_code
					expect(stage.seq).to eq stage_seq
				end

			end
		end
	end
end
