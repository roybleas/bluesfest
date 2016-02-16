require 'rails_helper'
require './app/services/load_service.rb'
require 'date'        

RSpec.describe "load services" do
	context "festival" do
		it "does not have a valid file name " do
			cLoad = LoadFestival.new('invalid')
			expect{cLoad.load}.to raise_error(/No such file or directory/)
		end
		
		it "creates festival record with corect details from csv file" do
			filename = './spec/files/festival.csv'
			cLoad = LoadFestival.new(filename)
			cLoad.load
			festival = Festival.take
			expect(festival.year).to eq("2016")
			expect(festival.startdate).to eq(Date.parse("2016-3-24"))
			expect(festival.days).to eq(5)
			expect(festival.scheduledate).to eq(Date.parse("2016-1-28"))
			expect(festival.title).to eq("Bluesfest")
			expect(festival.major).to eq(0)
			expect(festival.minor).to eq(1)
			expect(festival.active).to be_truthy
		end
		it "saves the new festival to the database" do
			filename = './spec/files/festival.csv'
			cLoad = LoadFestival.new(filename)
			expect{cLoad.load}.to change(Festival, :count).by(1)
		end
		it "updates the festival in the database" do
			festival = create(:festival, startdate: "2016-3-24")
			filename = './spec/files/festival.csv'
			cLoad = LoadFestival.new(filename)
			expect{cLoad.load}.to change(Festival, :count).by(0)
		end
 			
		it "outputs a message for each festival record created" do
			filename = './spec/files/festival.csv'
			cLoad = LoadFestival.new(filename)
			expect{ cLoad.load}.to output(/Loaded festival Bluesfest for 2016/).to_stdout
		end
	end
	
	context "current festival" do
		it "does not have a valid file name " do
			cCurrentFestival = CurrentFestival.new('invalid')
			expect{cCurrentFestival.load}.to raise_error(/No such file or directory/)
		end
		it "has corrupt yaml file" do
			cCurrentFestival = CurrentFestival.new('./spec/files/invalid.yml')
			expect{cCurrentFestival.load}.to raise_error(/mapping values are not allowed/)
		end			
		it "outputs a message to show current festival record" do
			filename = './spec/files/festival.yml'
			cCurrentFestival = CurrentFestival.new(filename)
			expect{ cCurrentFestival.load}.to output(/Loading for Bluesfest at 2016-03-24/).to_stdout
		end
		it "has correct attributes set" do
			filename = './spec/files/festival.yml'
			cCurrentFestival = CurrentFestival.new(filename)
			cCurrentFestival.load
			expect(cCurrentFestival.title).to eq "Bluesfest"
			expect(cCurrentFestival.startdate).to eq Date.parse("2016-03-24")
		end
		context "fetch festival id" do
			it "shows message when festival attributes not loaded" do
				filename = './spec/files/festival.yml'
				cCurrentFestival = CurrentFestival.new(filename)
				expect{cCurrentFestival.festival}.to output(/Error: No current festival data set/).to_stdout
			end
			it "returns nil festival id when festival does not exist" do
				filename = './spec/files/festival.yml'
				cCurrentFestival = CurrentFestival.new(filename)
				cCurrentFestival.load
				expect(cCurrentFestival.festival).to be_nil
			end
			context "festival ids exist" do
				before(:each) do
					filename = './spec/files/festival.yml'
					@cCurrentFestival = CurrentFestival.new(filename)
					@cCurrentFestival.load
				end
				it "current festival record does exist" do
					festival = festival = create(:festival, title: @cCurrentFestival.title, startdate: @cCurrentFestival.startdate)
					expect(@cCurrentFestival.festival).to eq(festival)
				end
				it "return nil when different start date" do
					festival = festival = create(:festival, title: @cCurrentFestival.title, startdate: "2015-04-05")
					expect(@cCurrentFestival.festival).to be_nil
				end
				it "return nil when different title" do
					festival = festival = create(:festival, title: "other festival", startdate: @cCurrentFestival.startdate)
					expect(@cCurrentFestival.festival).to be_nil
				end
			end
		end
	end
end